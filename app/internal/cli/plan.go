package cli

import (
	"fmt"

	"github.com/charmbracelet/log"
	"github.com/desertthunder/dotfiler/internal/ui"
	"github.com/spf13/cobra"
)

func planCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "plan",
		Short: "Print the setup plan without changing the machine",
		RunE: func(cmd *cobra.Command, args []string) error {
			log.Info("building setup plan")

			fmt.Fprintln(cmd.OutOrStdout(), ui.Section("Plan"))
			steps := []string{
				"detect platform: macOS, Ubuntu, or Fedora",
				"install package-manager prerequisites",
				"install packages from packages/{brew,apt,dnf}",
				"link portable dotfiles",
				"check SOPS age key presence",
				"optionally extract SSH keys from secrets/owais.yaml",
			}

			for i, step := range steps {
				fmt.Fprintf(cmd.OutOrStdout(), "%s %d. %s\n", ui.Bullet(), i+1, step)
			}

			return nil
		},
	}
}
