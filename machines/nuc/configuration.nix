{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "owais-nix-nuc";
  services.xserver.enable = pkgs.lib.mkForce false;
  services.xserver.displayManager.gdm.enable = pkgs.lib.mkForce false;
  services.xserver.desktopManager.gnome.enable = pkgs.lib.mkForce false;
  virtualisation.docker.enable = true;
  users.users.owais.extraGroups = [ "docker" ];
}
