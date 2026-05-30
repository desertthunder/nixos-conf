package system

import "os/exec"

func LookPath(name string) (string, bool) {
	path, err := exec.LookPath(name)
	return path, err == nil
}
