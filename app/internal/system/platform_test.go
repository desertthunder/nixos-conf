package system

import "testing"

func TestDetectPlatformReturnsOS(t *testing.T) {
	p := DetectPlatform()
	if p.OS == "" {
		t.Fatal("expected OS to be populated")
	}
}
