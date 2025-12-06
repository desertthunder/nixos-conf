# HP-specific configuration
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "owais-nix-hp";

  # TODO: Add HP-specific configuration here
  # Examples:
  # - hardware.bluetooth.enable = true;
  # - services.blueman.enable = true;
  # - Hardware-specific drivers
  # - Display/graphics optimizations
}
