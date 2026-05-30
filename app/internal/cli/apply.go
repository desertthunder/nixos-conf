package cli

import (
	"fmt"

	"github.com/charmbracelet/log"
	"github.com/desertthunder/dotfiler/internal/ui"
	"github.com/spf13/cobra"
)

func applyCommand(app *dotfiler) *cobra.Command {
	var only string

	cmd := &cobra.Command{
		Use:   "apply",
		Short: "Apply setup steps",
		RunE: func(cmd *cobra.Command, args []string) error {
			log.Info("apply requested", "dry_run", app.dryRun, "only", only)

			if app.dryRun {
				fmt.Fprintln(cmd.OutOrStdout(), ui.Warning("dry run: no changes will be made"))
			}

			fmt.Fprintln(cmd.OutOrStdout(), ui.Section("Apply"))
			fmt.Fprintln(cmd.OutOrStdout(), "Implementation pending. Use `dotfiler plan` for the intended flow.")
			return nil
		},
	}

	cmd.Flags().StringVar(&only, "only", "", "limit apply to one area: packages, dotfiles, or secrets")
	return cmd
}
