package cli

import (
	"fmt"

	"github.com/desertthunder/dotfiler/internal/ui"
	"github.com/spf13/cobra"
)

func sparseCommand() *cobra.Command {
	var url string
	var path string
	var dest string

	cmd := &cobra.Command{
		Use:   "sparse",
		Short: "Sparse-clone a path from a GitHub repository",
		Long:  "Planned Go replacement for scripts/gc-sparse.sh.",
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Fprintln(cmd.OutOrStdout(), ui.Section("Sparse clone"))
			fmt.Fprintf(cmd.OutOrStdout(), "url:  %s\n", url)
			fmt.Fprintf(cmd.OutOrStdout(), "path: %s\n", path)
			fmt.Fprintf(cmd.OutOrStdout(), "dest: %s\n", dest)
			fmt.Fprintln(cmd.OutOrStdout(), ui.Muted("Implementation pending; current script: scripts/gc-sparse.sh"))
			return nil
		},
	}

	cmd.Flags().StringVar(&url, "url", "", "GitHub repository URL")
	cmd.Flags().StringVar(&path, "path", "", "repository path to sparse-clone")
	cmd.Flags().StringVar(&dest, "dest", "", "destination directory")
	return cmd
}
