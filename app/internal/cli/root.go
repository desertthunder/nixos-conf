package cli

import (
	"fmt"
	"os"
	"time"

	"github.com/charmbracelet/log"
	"github.com/desertthunder/dotfiler/internal/ui"
	"github.com/spf13/cobra"
)

type dotfiler struct {
	verbose bool
	dryRun  bool
}

var Dotfiler = dotfiler{}

type dottools struct {
	verbose bool
}

var Dottools = dottools{}

func (d dotfiler) Execute() {
	cmd := d.Command()
	if err := cmd.Execute(); err != nil {
		log.Error("command failed", "err", err)
		os.Exit(1)
	}
}

func (d dotfiler) Command() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "dotfiler",
		Short: "Deterministic-ish setup for non-Nix machines",
		Long: ui.Title("dotfiler") + "\n\n" +
			"A small installer/orchestrator for macOS, Ubuntu, and Fedora machines that do not run Nix.",
		PersistentPreRun: func(cmd *cobra.Command, args []string) {
			setupLogger("dotfiler", d.verbose)
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			return cmd.Help()
		},
	}

	cmd.PersistentFlags().BoolVarP(&d.verbose, "verbose", "v", false, "enable debug logging")
	cmd.PersistentFlags().BoolVar(&d.dryRun, "dry-run", false, "show intended changes without applying them")

	cmd.AddCommand(doctorCommand())
	cmd.AddCommand(planCommand())
	cmd.AddCommand(applyCommand(&d))
	cmd.AddCommand(packagesCommand(&d))
	cmd.AddCommand(dotfilesCommand(&d))
	cmd.AddCommand(secretsCommand(&d))
	cmd.AddCommand(dotfilerVersionCommand())

	return cmd
}

func (d dottools) Execute() {
	cmd := d.Command()
	if err := cmd.Execute(); err != nil {
		log.Error("command failed", "err", err)
		os.Exit(1)
	}
}

func (d dottools) Command() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "dottools",
		Short: "Utility commands for dotfiles maintenance",
		Long: ui.Title("dottools") + "\n\n" +
			"Day-to-day utilities ported from scripts/: disk analysis, project analysis, and sparse clones.",
		PersistentPreRun: func(cmd *cobra.Command, args []string) {
			setupLogger("dottools", d.verbose)
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			return cmd.Help()
		},
	}

	cmd.PersistentFlags().BoolVarP(&d.verbose, "verbose", "v", false, "enable debug logging")

	cmd.AddCommand(diskCommand())
	cmd.AddCommand(projectCommand())
	cmd.AddCommand(sparseCommand())
	cmd.AddCommand(dottoolsVersionCommand())

	return cmd
}

func setupLogger(prefix string, verbose bool) {
	logger := log.NewWithOptions(os.Stderr, log.Options{
		ReportCaller:    verbose,
		ReportTimestamp: true,
		Prefix:          prefix,
		TimeFormat:      time.Kitchen,
	})
	if verbose {
		logger.SetLevel(log.DebugLevel)
	} else {
		logger.SetLevel(log.InfoLevel)
	}
	log.SetDefault(logger)
}

func dotfilerVersionCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "version",
		Short: "Print version information",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Fprintln(cmd.OutOrStdout(), "dotfiler dev")
		},
	}
}

func dottoolsVersionCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "version",
		Short: "Print version information",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Fprintln(cmd.OutOrStdout(), "dottools dev")
		},
	}
}
