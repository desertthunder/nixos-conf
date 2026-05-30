package cli

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/desertthunder/dotfiler/internal/runner"
	"github.com/desertthunder/dotfiler/internal/system"
	"github.com/desertthunder/dotfiler/internal/ui"
	"github.com/spf13/cobra"
)

func packagesCommand(app *dotfiler) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "packages",
		Short: "Plan and install platform packages",
	}
	cmd.AddCommand(packagesPlanCommand())
	cmd.AddCommand(packagesApplyCommand(app))
	return cmd
}

func packagesPlanCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "plan",
		Short: "Show package files and package manager for this host",
		RunE: func(cmd *cobra.Command, args []string) error {
			root, err := system.FindRepoRoot("")
			if err != nil {
				return err
			}
			platform := system.DetectPlatform()
			fmt.Fprintln(cmd.OutOrStdout(), ui.Section("Packages"))
			fmt.Fprintf(cmd.OutOrStdout(), "platform: %s/%s\n", platform.OS, platform.Distribution)
			fmt.Fprintf(cmd.OutOrStdout(), "manager:  %s\n", platform.PackageManager)
			for _, file := range packageFiles(root, platform) {
				fmt.Fprintf(cmd.OutOrStdout(), "%s %s\n", ui.Bullet(), file)
			}
			return nil
		},
	}
}

func packagesApplyCommand(app *dotfiler) *cobra.Command {
	return &cobra.Command{
		Use:   "apply",
		Short: "Install packages using the host package manager",
		RunE: func(cmd *cobra.Command, args []string) error {
			root, err := system.FindRepoRoot("")
			if err != nil {
				return err
			}
			platform := system.DetectPlatform()
			if !platform.Supported {
				return fmt.Errorf("unsupported platform: %s/%s", platform.OS, platform.Distribution)
			}

			r := runner.Runner{DryRun: app.dryRun}
			switch platform.PackageManager {
			case "brew":
				for _, file := range packageFiles(root, platform) {
					if err := r.Run("brew", "bundle", "--file", file); err != nil {
						return err
					}
				}
			case "apt":
				pkgs, err := readPackageList(filepath.Join(root, "packages", "apt", "packages.txt"))
				if err != nil {
					return err
				}
				args := append([]string{"apt-get", "install", "-y"}, pkgs...)
				return r.Run("sudo", args...)
			case "dnf":
				pkgs, err := readPackageList(filepath.Join(root, "packages", "dnf", "packages.txt"))
				if err != nil {
					return err
				}
				args := append([]string{"dnf", "install", "-y"}, pkgs...)
				return r.Run("sudo", args...)
			}
			return nil
		},
	}
}

func packageFiles(root string, platform system.Platform) []string {
	switch platform.PackageManager {
	case "brew":
		files := []string{filepath.Join(root, "packages", "brew", "Brewfile.common")}
		host, _ := os.Hostname()
		if host != "" {
			candidate := filepath.Join(root, "packages", "brew", "Brewfile."+strings.ToLower(host))
			if _, err := os.Stat(candidate); err == nil {
				files = append(files, candidate)
			}
		}
		return existingFiles(files)
	case "apt":
		return existingFiles([]string{filepath.Join(root, "packages", "apt", "packages.txt")})
	case "dnf":
		return existingFiles([]string{filepath.Join(root, "packages", "dnf", "packages.txt")})
	default:
		return nil
	}
}

func existingFiles(files []string) []string {
	var out []string
	for _, file := range files {
		if _, err := os.Stat(file); err == nil {
			out = append(out, file)
		}
	}
	return out
}

func readPackageList(path string) ([]string, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	var pkgs []string
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		pkgs = append(pkgs, line)
	}
	return pkgs, scanner.Err()
}
