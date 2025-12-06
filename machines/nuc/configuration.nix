# NUC-specific configuration
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "owais-nix-nuc";

  # TODO: Add NUC-specific configuration here
  # Examples:
  # - Hardware-specific drivers
  # - Performance optimizations
  # - Special services or features
}
