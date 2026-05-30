# Dell-specific configuration
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
  ];

  networking.hostName = "owais-nix-dell";

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
}
