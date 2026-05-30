package cli

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/charmbracelet/log"
)

type runner struct {
	dryRun bool
}

func command(name string, args ...string) *exec.Cmd {
	return exec.Command(name, args...)
}

func (r runner) run(name string, args ...string) error {
	log.Info("run", "cmd", commandString(name, args), "dry_run", r.dryRun)
	if r.dryRun {
		fmt.Println(commandString(name, args))
		return nil
	}

	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	return cmd.Run()
}

func commandString(name string, args []string) string {
	parts := append([]string{name}, args...)
	return strings.Join(parts, " ")
}
