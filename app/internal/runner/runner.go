package runner

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/charmbracelet/log"
)

type Runner struct {
	DryRun bool
}

func Command(name string, args ...string) *exec.Cmd {
	return exec.Command(name, args...)
}

func (r Runner) Run(name string, args ...string) error {
	log.Info("run", "cmd", commandString(name, args), "dry_run", r.DryRun)
	if r.DryRun {
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
