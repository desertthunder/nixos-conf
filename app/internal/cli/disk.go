package cli

import (
	"fmt"

	"github.com/spf13/cobra"
)

func diskCommand() *cobra.Command {
	var dir string
	var mode string

	cmd := &cobra.Command{
		Use:   "disk",
		Short: "Analyze disk usage",
		Long:  "Planned Go replacement for scripts/analyze-disk.sh.",
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Fprintln(cmd.OutOrStdout(), Section("Disk analyzer"))
			fmt.Fprintf(cmd.OutOrStdout(), "dir:  %s\n", dir)
			fmt.Fprintf(cmd.OutOrStdout(), "mode: %s\n", mode)
			fmt.Fprintln(cmd.OutOrStdout(), Muted("Implementation pending; current script: scripts/analyze-disk.sh"))
			return nil
		},
	}

	cmd.Flags().StringVarP(&dir, "dir", "d", "$HOME", "directory to analyze")
	cmd.Flags().StringVarP(&mode, "mode", "m", "all", "mode: overview, large, search, all")
	return cmd
}
