{ ... }:

{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  security.pam.services.hyprlock = { };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  systemd.services.display-manager.restartIfChanged = false;
  systemd.services.display-manager.stopIfChanged = false;
}
