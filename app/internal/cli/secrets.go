package cli

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/desertthunder/dotfiler/internal/runner"
	"github.com/desertthunder/dotfiler/internal/system"
	"github.com/desertthunder/dotfiler/internal/ui"
	"github.com/spf13/cobra"
)

func secretsCommand(app *dotfiler) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "secrets",
		Short: "Check and extract SOPS secrets",
	}
	cmd.AddCommand(secretsCheckCommand())
	cmd.AddCommand(secretsExtractSSHCommand(app))
	return cmd
}

func secretsCheckCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "check",
		Short: "Check SOPS, age, and age key availability",
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Fprintln(cmd.OutOrStdout(), ui.Section("Secrets"))
			for _, tool := range []string{"sops", "age"} {
				path, ok := system.LookPath(tool)
				if ok {
					fmt.Fprintf(cmd.OutOrStdout(), "%s %s %s\n", ui.Success("✓"), tool, ui.Muted(path))
				} else {
					fmt.Fprintf(cmd.OutOrStdout(), "%s %s missing\n", ui.Warning("!"), tool)
				}
			}
			keyFile := sopsAgeKeyFile()
			if _, err := os.Stat(keyFile); err == nil {
				fmt.Fprintf(cmd.OutOrStdout(), "%s age key %s\n", ui.Success("✓"), ui.Muted(keyFile))
			} else {
				fmt.Fprintf(cmd.OutOrStdout(), "%s age key missing at %s\n", ui.Warning("!"), keyFile)
			}
			return nil
		},
	}
}

func secretsExtractSSHCommand(app *dotfiler) *cobra.Command {
	return &cobra.Command{
		Use:   "extract-ssh",
		Short: "Extract SSH keys from secrets/owais.yaml",
		RunE: func(cmd *cobra.Command, args []string) error {
			root, err := system.FindRepoRoot("")
			if err != nil {
				return err
			}
			secretsFile := filepath.Join(root, "secrets", "owais.yaml")
			dest := filepath.Join(homeDir(), ".local", "share", "sops")
			if !app.dryRun {
				if err := os.MkdirAll(dest, 0o700); err != nil {
					return err
				}
			}

			for _, key := range []string{"keys_gh", "keys_codeberg", "keys_tangled"} {
				out := filepath.Join(dest, key)
				if app.dryRun {
					fmt.Fprintf(cmd.OutOrStdout(), "SOPS_AGE_KEY_FILE=%s sops --extract '[\"%s\"]' -d %s > %s\n", sopsAgeKeyFile(), key, secretsFile, out)
					continue
				}
				if err := extractSecret(secretsFile, key, out); err != nil {
					return err
				}
				if err := os.Chmod(out, 0o600); err != nil {
					return err
				}
				fmt.Fprintf(cmd.OutOrStdout(), "%s wrote %s\n", ui.Success("✓"), out)
			}
			return nil
		},
	}
}

func extractSecret(secretsFile, key, out string) error {
	cmd := runner.Command("sops", "--extract", fmt.Sprintf("[\"%s\"]", key), "-d", secretsFile)
	cmd.Env = append(os.Environ(), "SOPS_AGE_KEY_FILE="+sopsAgeKeyFile())
	data, err := cmd.Output()
	if err != nil {
		return err
	}
	return os.WriteFile(out, data, 0o600)
}

func sopsAgeKeyFile() string {
	if v := os.Getenv("SOPS_AGE_KEY_FILE"); v != "" {
		return v
	}
	return filepath.Join(homeDir(), ".config", "sops", "age", "keys.txt")
}
