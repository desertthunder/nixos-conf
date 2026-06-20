{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    grim
    hypridle
    hyprlock
    hyprpaper
    hyprpolkitagent
    libnotify
    mako
    playerctl
    rofi
    rofi-power-menu
    satty
    slurp
    waybar
    wl-clipboard
  ];

  systemd.user.services.hyprpaper = {
    Unit = {
      Description = "Hyprpaper wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper --config %h/.config/hypr/hyprpaper.conf";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.hypridle = {
    Unit = {
      Description = "Hypridle idle daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      ExecStart = "${pkgs.hypridle}/bin/hypridle --config %h/.config/hypr/hypridle.conf";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.mako = {
    Unit = {
      Description = "Mako notification daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."hypr/hyprland.lua".source = ../hypr/hyprland.lua;
  xdg.configFile."hypr/hypridle.conf".source = ../hypr/hypridle.conf;
  xdg.configFile."hypr/shot.sh" = {
    source = ../hypr/shot.sh;
    executable = true;
  };
  xdg.configFile."hypr/wallpapers" = {
    source = ../hypr/wallpapers;
    recursive = true;
  };
  xdg.configFile."hypr/hyprpaper.conf".text =
    let
      wallpaper = "${../hypr/wallpapers/wall00.png}";
    in
    ''
      splash = false

      wallpaper {
        monitor =
        path = ${wallpaper}
        fit_mode = cover
      }
    '';

  xdg.configFile."rofi" = {
    source = ../rofi;
    recursive = true;
  };

  xdg.configFile."waybar" = {
    source = ../waybar;
    recursive = true;
  };

  xdg.configFile."mako/config".text = ''
    font=Inter 12
    anchor=top-right
    width=360
    height=120
    margin=12
    padding=12
    border-size=1
    border-radius=8
    default-timeout=5000
    icons=1
    max-icon-size=64

    background-color=#151516
    text-color=#cfcfcf
    border-color=#2a2a2a
    progress-color=over #51a4e7

    [urgency=low]
    default-timeout=3000
    border-color=#2a2a2a

    [urgency=critical]
    default-timeout=0
    border-color=#e55f86
  '';

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
