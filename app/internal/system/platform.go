package system

import (
	"bufio"
	"os"
	"runtime"
	"strings"
)

type Platform struct {
	OS             string
	Distribution   string
	PackageManager string
	Supported      bool
}

func DetectPlatform() Platform {
	p := Platform{OS: runtime.GOOS}

	switch runtime.GOOS {
	case "darwin":
		p.Distribution = "macos"
		p.PackageManager = "brew"
	case "linux":
		p.Distribution = linuxID()
		switch p.Distribution {
		case "ubuntu", "debian":
			p.PackageManager = "apt"
		case "fedora":
			p.PackageManager = "dnf"
		}
	}

	p.Supported = p.PackageManager != ""
	return p
}

func linuxID() string {
	f, err := os.Open("/etc/os-release")
	if err != nil {
		return "linux"
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := scanner.Text()
		key, value, ok := strings.Cut(line, "=")
		if !ok || key != "ID" {
			continue
		}
		return strings.Trim(strings.ToLower(value), `"'`)
	}
	return "linux"
}
