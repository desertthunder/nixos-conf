package cli

import (
	"fmt"
	"os"

	"github.com/charmbracelet/log"
	internalsite "github.com/desertthunder/dotfiler/internal/site"
	"github.com/desertthunder/dotfiler/internal/system"
	"github.com/spf13/cobra"
)

type siteCLI struct {
	verbose bool
	addr    string
}

var Site = siteCLI{}

func (s siteCLI) Execute() {
	cmd := s.Command()
	if err := cmd.Execute(); err != nil {
		log.Error("command failed", "err", err)
		os.Exit(1)
	}
}

func (s siteCLI) Command() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "site",
		Short: "Build and serve the documentation site",
		PersistentPreRun: func(cmd *cobra.Command, args []string) {
			setupLogger("site", s.verbose)
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			return cmd.Help()
		},
	}
	cmd.PersistentFlags().BoolVarP(&s.verbose, "verbose", "v", false, "enable debug logging")

	cmd.AddCommand(siteBuildCommand())
	cmd.AddCommand(siteServeCommand(&s))
	cmd.AddCommand(sitePreviewCommand(&s))
	cmd.AddCommand(siteCleanCommand())
	cmd.AddCommand(siteCheckCommand())
	cmd.AddCommand(siteIndexCommand())
	cmd.AddCommand(siteVersionCommand())
	return cmd
}

func siteBuildCommand() *cobra.Command {
	var staticOnly bool
	cmd := &cobra.Command{
		Use:   "build",
		Short: "Build the static documentation site and search index",
		RunE: func(cmd *cobra.Command, args []string) error {
			cfg, err := siteConfig()
			if err != nil {
				return err
			}
			if err := internalsite.Build(cfg); err != nil {
				return err
			}
			if staticOnly {
				return nil
			}
			return internalsite.Pagefind(cfg)
		},
	}
	cmd.Flags().BoolVar(&staticOnly, "static", false, "build HTML and assets without running Pagefind")
	return cmd
}

func siteServeCommand(app *siteCLI) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "serve",
		Short: "Serve the generated site locally",
		RunE: func(cmd *cobra.Command, args []string) error {
			cfg, err := siteConfig()
			if err != nil {
				return err
			}
			return internalsite.Serve(cfg, app.addr)
		},
	}
	cmd.Flags().StringVar(&app.addr, "addr", ":8080", "address to serve on")
	return cmd
}

func sitePreviewCommand(app *siteCLI) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "preview",
		Short: "Build, open, and serve the generated site locally",
		RunE: func(cmd *cobra.Command, args []string) error {
			cfg, err := siteConfig()
			if err != nil {
				return err
			}
			return internalsite.Preview(cfg, app.addr)
		},
	}
	cmd.Flags().StringVar(&app.addr, "addr", ":8080", "address to serve on")
	return cmd
}

func siteCleanCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "clean",
		Short: "Remove generated site output",
		RunE: func(cmd *cobra.Command, args []string) error {
			cfg, err := siteConfig()
			if err != nil {
				return err
			}
			return internalsite.Clean(cfg)
		},
	}
}

func siteCheckCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "check",
		Short: "Validate site content",
		RunE: func(cmd *cobra.Command, args []string) error {
			cfg, err := siteConfig()
			if err != nil {
				return err
			}
			return internalsite.Check(cfg)
		},
	}
}

func siteIndexCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "index",
		Short: "Run Pagefind against the generated site",
		RunE: func(cmd *cobra.Command, args []string) error {
			cfg, err := siteConfig()
			if err != nil {
				return err
			}
			return internalsite.Pagefind(cfg)
		},
	}
}

func siteVersionCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "version",
		Short: "Print version information",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Fprintln(cmd.OutOrStdout(), "site dev")
		},
	}
}

func siteConfig() (internalsite.Config, error) {
	root, err := system.FindRepoRoot("")
	if err != nil {
		return internalsite.Config{}, err
	}
	return internalsite.DefaultConfig(root), nil
}
