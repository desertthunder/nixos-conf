# HP-specific configuration
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ../../shared.nix).nixos
  ];

  networking.hostName = "nix-baxcalibur";

  # TODO: Add HP-specific configuration here
  # Examples:
  # - hardware.bluetooth.enable = true;
  # - services.blueman.enable = true;
  # - Hardware-specific drivers
  # - Display/graphics optimizations
}
