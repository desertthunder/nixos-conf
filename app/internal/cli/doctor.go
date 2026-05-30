package cli

import (
	"fmt"
	"runtime"

	"github.com/charmbracelet/log"
	"github.com/desertthunder/dotfiler/internal/system"
	"github.com/spf13/cobra"
)

func doctorCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "doctor",
		Short: "Check host platform and required tools",
		RunE: func(cmd *cobra.Command, args []string) error {
			platform := system.DetectPlatform()
			log.Info("running host checks", "os", runtime.GOOS, "arch", runtime.GOARCH, "package_manager", platform.PackageManager)

			fmt.Fprintln(cmd.OutOrStdout(), Section("Host"))
			fmt.Fprintf(cmd.OutOrStdout(), "OS:      %s\n", runtime.GOOS)
			fmt.Fprintf(cmd.OutOrStdout(), "Arch:    %s\n", runtime.GOARCH)
			fmt.Fprintf(cmd.OutOrStdout(), "Distro:  %s\n", platform.Distribution)
			fmt.Fprintf(cmd.OutOrStdout(), "Manager: %s\n\n", platform.PackageManager)

			fmt.Fprintln(cmd.OutOrStdout(), Section("Tools"))
			tools := []string{"git", "sops", "age"}
			if platform.PackageManager != "" {
				tools = append(tools, platform.PackageManager)
			}
			for _, tool := range tools {
				path, ok := system.LookPath(tool)
				if ok {
					fmt.Fprintf(cmd.OutOrStdout(), "%s %s %s\n", Success("✓"), tool, Muted(path))
					continue
				}
				fmt.Fprintf(cmd.OutOrStdout(), "%s %s\n", Warning("!"), tool)
			}

			return nil
		},
	}
}
