package cli

import (
	"fmt"
	"runtime"

	"github.com/charmbracelet/log"
	"github.com/desertthunder/dotfiler/internal/system"
	"github.com/desertthunder/dotfiler/internal/ui"
	"github.com/spf13/cobra"
)

func doctorCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "doctor",
		Short: "Check host platform and required tools",
		RunE: func(cmd *cobra.Command, args []string) error {
			log.Info("running host checks", "os", runtime.GOOS, "arch", runtime.GOARCH)

			fmt.Fprintln(cmd.OutOrStdout(), ui.Section("Host"))
			fmt.Fprintf(cmd.OutOrStdout(), "OS:   %s\n", runtime.GOOS)
			fmt.Fprintf(cmd.OutOrStdout(), "Arch: %s\n\n", runtime.GOARCH)

			fmt.Fprintln(cmd.OutOrStdout(), ui.Section("Tools"))
			for _, tool := range []string{"git", "sops", "age"} {
				path, ok := system.LookPath(tool)
				if ok {
					fmt.Fprintf(cmd.OutOrStdout(), "%s %s %s\n", ui.Success("✓"), tool, ui.Muted(path))
					continue
				}
				fmt.Fprintf(cmd.OutOrStdout(), "%s %s\n", ui.Warning("!"), tool)
			}

			return nil
		},
	}
}
