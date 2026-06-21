# HP-specific configuration
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ../../shared.nix).nixos
    ../../services/forgejo.nix
  ];

  networking.hostName = "nix-baxcalibur";

  desert.services.gitForge = {
    enable = true;

    cloudflareTunnel.enable = true;
    cloudflareTunnel.tunnelId = "71856287-3b7f-48dc-b80d-d4c8e452c384";
  };
}
