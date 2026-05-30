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

			switch only {
			case "", "all":
				if err := packagesApplyCommand(app).RunE(cmd, nil); err != nil {
					return err
				}
				if err := dotfilesApplyCommand(app).RunE(cmd, nil); err != nil {
					return err
				}
				return secretsCheckCommand().RunE(cmd, nil)
			case "packages":
				return packagesApplyCommand(app).RunE(cmd, nil)
			case "dotfiles":
				return dotfilesApplyCommand(app).RunE(cmd, nil)
			case "secrets":
				return secretsExtractSSHCommand(app).RunE(cmd, nil)
			default:
				return fmt.Errorf("unknown --only value %q; use packages, dotfiles, secrets, or all", only)
			}
		},
	}

	cmd.Flags().StringVar(&only, "only", "", "limit apply to one area: packages, dotfiles, secrets, or all")
	return cmd
}
