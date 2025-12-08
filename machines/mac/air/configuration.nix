# macOS-specific system settings
# See: https://nix-darwin.github.io/nix-darwin/manual/
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../shared/darwin-configuration.nix
  ];

  networking.hostName = "owais-nix-air";
  networking.computerName = "Owais MacBook Air";

  system.primaryUser = "owais";
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
      persistent-apps = [
        "/Applications/Ghostty.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Google Chrome.app"
      ];
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.trackpad.enableSecondaryClick" = true;
    };

    trackpad = {
      Clicking = true; # Tap to click
      TrackpadRightClick = true;
    };

    screencapture.location = "~/Pictures/Screenshots";
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
