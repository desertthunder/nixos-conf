{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ../../shared.nix).nixos
    ../../modules/de/hypr.nix
  ];

  networking.hostName = "nix-haxorus";

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      TLP_DEFAULT_MODE = "BAT";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  services.fprintd.enable = true;
}
