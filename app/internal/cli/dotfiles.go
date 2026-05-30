package cli

import (
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/desertthunder/dotfiler/internal/system"
	"github.com/spf13/cobra"
)

type dotfileLink struct {
	Source string
	Target string
}

func dotfilesCommand(app *dotfiler) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "dotfiles",
		Short: "Plan and link portable dotfiles",
	}
	cmd.AddCommand(dotfilesPlanCommand())
	cmd.AddCommand(dotfilesApplyCommand(app))
	return cmd
}

func dotfilesPlanCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "plan",
		Short: "Show dotfile links",
		RunE: func(cmd *cobra.Command, args []string) error {
			root, err := system.FindRepoRoot("")
			if err != nil {
				return err
			}
			fmt.Fprintln(cmd.OutOrStdout(), Section("Dotfiles"))
			for _, link := range dotfileLinks(root) {
				fmt.Fprintf(cmd.OutOrStdout(), "%s %s -> %s\n", Bullet(), link.Target, link.Source)
			}
			return nil
		},
	}
}

func dotfilesApplyCommand(app *dotfiler) *cobra.Command {
	return &cobra.Command{
		Use:   "apply",
		Short: "Symlink portable dotfiles into $HOME",
		RunE: func(cmd *cobra.Command, args []string) error {
			root, err := system.FindRepoRoot("")
			if err != nil {
				return err
			}
			backupDir := filepath.Join(homeDir(), ".dotfiles-backup", time.Now().Format("20060102-150405"))
			for _, link := range dotfileLinks(root) {
				if app.dryRun {
					fmt.Fprintf(cmd.OutOrStdout(), "ln -s %s %s\n", link.Source, link.Target)
					continue
				}
				if err := linkDotfile(link.Source, link.Target, backupDir); err != nil {
					return err
				}
				fmt.Fprintf(cmd.OutOrStdout(), "%s linked %s\n", Success("✓"), link.Target)
			}
			return nil
		},
	}
}

func dotfileLinks(root string) []dotfileLink {
	home := homeDir()
	return []dotfileLink{
		{filepath.Join(root, "lib", "dotfiles", "zsh", ".zshrc"), filepath.Join(home, ".zshrc")},
		{filepath.Join(root, "lib", "dotfiles", "git", ".gitconfig"), filepath.Join(home, ".gitconfig")},
		{filepath.Join(root, "lib", "dotfiles", "ghostty", ".config", "ghostty", "config"), filepath.Join(home, ".config", "ghostty", "config")},
		{filepath.Join(root, "lib", "dotfiles", "ripgrep", ".config", "ripgrep", "config"), filepath.Join(home, ".config", "ripgrep", "config")},
		{filepath.Join(root, "lib", "dotfiles", "zellij", ".config", "zellij"), filepath.Join(home, ".config", "zellij")},
		{filepath.Join(root, "lib", "dotfiles", "oh-my-posh", ".config", "oh-my-posh", "theme.json"), filepath.Join(home, ".config", "oh-my-posh", "theme.json")},
	}
}

func linkDotfile(source, target, backupDir string) error {
	if _, err := os.Stat(source); err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
		return err
	}
	if info, err := os.Lstat(target); err == nil {
		if info.Mode()&os.ModeSymlink != 0 {
			if err := os.Remove(target); err != nil {
				return err
			}
		} else {
			backup := filepath.Join(backupDir, relativeHomePath(target))
			if err := os.MkdirAll(filepath.Dir(backup), 0o755); err != nil {
				return err
			}
			if err := os.Rename(target, backup); err != nil {
				return err
			}
		}
	}
	return os.Symlink(source, target)
}

func relativeHomePath(path string) string {
	rel, err := filepath.Rel(homeDir(), path)
	if err != nil || rel == "." || rel == "" {
		return filepath.Base(path)
	}
	return rel
}

func homeDir() string {
	home, err := os.UserHomeDir()
	if err != nil {
		return ""
	}
	return home
}
