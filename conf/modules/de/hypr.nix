{ ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  security.pam.services.hyprlock = { };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GNOME enables IBus by default, but Haxorus only uses the US XKB layout.
  # Its generic autostart command is not valid for a Hyprland Wayland session.
  i18n.inputMethod.enable = false;

  systemd.services.display-manager.restartIfChanged = false;
  systemd.services.display-manager.stopIfChanged = false;
}
