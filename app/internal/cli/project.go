package cli

import (
	"fmt"

	"github.com/desertthunder/dotfiler/internal/ui"
	"github.com/spf13/cobra"
)

func projectCommand() *cobra.Command {
	var dir string
	var mode string
	var threshold int

	cmd := &cobra.Command{
		Use:   "project",
		Short: "Analyze source project size and shape",
		Long:  "Planned Go replacement for scripts/analyze-project.sh.",
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Fprintln(cmd.OutOrStdout(), ui.Section("Project analyzer"))
			fmt.Fprintf(cmd.OutOrStdout(), "dir:       %s\n", dir)
			fmt.Fprintf(cmd.OutOrStdout(), "mode:      %s\n", mode)
			fmt.Fprintf(cmd.OutOrStdout(), "threshold: %d\n", threshold)
			fmt.Fprintln(cmd.OutOrStdout(), ui.Muted("Implementation pending; current script: scripts/analyze-project.sh"))
			return nil
		},
	}

	cmd.Flags().StringVarP(&dir, "dir", "d", ".", "directory to analyze")
	cmd.Flags().StringVarP(&mode, "mode", "m", "all", "mode: loc, words, files, big, all")
	cmd.Flags().IntVarP(&threshold, "threshold", "t", 1000, "line threshold for big-file detection")
	return cmd
}
