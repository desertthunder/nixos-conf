{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "owais-nix-hp";
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
