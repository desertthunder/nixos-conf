{ config, pkgs, ... }:

let
  clipboardPicker = pkgs.writeShellApplication {
    name = "clipboard-picker";
    runtimeInputs = with pkgs; [
      cliphist
      rofi
      wl-clipboard
    ];
    text = ''
      selection="$(cliphist list | rofi -dmenu -p Clipboard)"
      [ -n "$selection" ] || exit 0
      printf '%s' "$selection" | cliphist decode | wl-copy
    '';
  };

  clearClipboardHistory = pkgs.writeShellApplication {
    name = "clear-clipboard-history";
    runtimeInputs = with pkgs; [
      cliphist
      rofi
      wl-clipboard
    ];
    text = ''
      choice="$(printf 'Cancel\nClear\n' | rofi -dmenu -p 'Clear clipboard history?')"
      [ "$choice" = Clear ] || exit 0
      cliphist wipe
      wl-copy --clear
    '';
  };

  notificationStatus = pkgs.writeShellApplication {
    name = "notification-status";
    runtimeInputs = with pkgs; [
      gnugrep
      mako
    ];
    text = ''
      if makoctl mode | grep -qx do-not-disturb; then
        printf 'notifications off\n'
      else
        printf 'notifications\n'
      fi
    '';
  };
in
{
  home.packages = with pkgs; [
    brightnessctl
    clearClipboardHistory
    clipboardPicker
    cliphist
    grim
    hypridle
    hyprlock
    hyprpaper
    hyprpolkitagent
    libnotify
    mako
    notificationStatus
    playerctl
    rofi
    rofi-power-menu
    satty
    slurp
    swayosd
    waybar
    wl-clipboard
  ];

  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland Polkit authentication agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

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

  systemd.user.services.cliphist-text = {
    Unit = {
      Description = "Cliphist text clipboard watcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.cliphist-image = {
    Unit = {
      Description = "Cliphist image clipboard watcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.swayosd = {
    Unit = {
      Description = "SwayOSD on-screen display server";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
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
  xdg.configFile."hypr/hyprlock.conf".text =
    let
      wallpaper = "${../wallpapers/wall00.png}";
    in
    ''
      general {
        disable_loading_bar = true
        hide_cursor = true
      }

      background {
        monitor =
        path = ${wallpaper}
        blur_passes = 2
        blur_size = 4
        color = rgb(151516)
      }

      label {
        monitor =
        text = cmd[update:1000] date +"%H:%M"
        color = rgb(cfcfcf)
        font_family = Inter
        font_size = 72
        position = 0, 100
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:60000] date +"%A, %d %B"
        color = rgb(7a7a7a)
        font_family = Inter
        font_size = 18
        position = 0, 35
        halign = center
        valign = center
      }

      input-field {
        monitor =
        size = 320, 48
        outline_thickness = 1
        dots_size = 0.22
        dots_spacing = 0.3
        outer_color = rgb(2a2a2a)
        inner_color = rgb(151516)
        font_color = rgb(cfcfcf)
        fade_on_empty = false
        placeholder_text = <span foreground="##7a7a7a">Password</span>
        check_color = rgb(51a4e7)
        fail_color = rgb(e55f86)
        position = 0, -45
        halign = center
        valign = center
      }
    '';
  xdg.configFile."hypr/shot.sh" = {
    source = ../hypr/shot.sh;
    executable = true;
  };
  xdg.configFile."hypr/wallpapers" = {
    source = ../wallpapers;
    recursive = true;
  };
  xdg.configFile."hypr/hyprpaper.conf".text =
    let
      wallpaper = "${../wallpapers/wall00.png}";
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

    [mode=do-not-disturb]
    invisible=1
  '';

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
