# NUC-specific configuration
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "owais-nix-nuc";

  # NUC-specific settings belong here once the host is finalized.
}
