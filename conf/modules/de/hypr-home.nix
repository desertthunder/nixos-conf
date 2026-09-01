{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  theme = import ./desktop-theme.nix;
  colors = theme.colors;
  themeValues = colors // theme.fonts;
  renderTheme =
    path:
    pkgs.writeText (baseNameOf path) (
      lib.replaceStrings (map (name: "{{${name}}}") (builtins.attrNames themeValues)) (map (
        name: themeValues.${name}
      ) (builtins.attrNames themeValues)) (builtins.readFile path)
    );

  # Ignis 0.5.1 hard-codes Python 3.12 in its launcher, while Meson installs
  # its modules under the current Python directory. Keep both sides aligned.
  ignis = inputs.ignis.packages.${pkgs.system}.default.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      target="$out/lib/python3.12/site-packages"
      mkdir -p "$target"
      for site in "$out"/lib/python3.*/site-packages; do
        if [ "$site" != "$target" ]; then
          cp -r "$site"/. "$target"/
          rm -r "$site"
        fi
      done
    '';
  });

  screenshot = pkgs.writeShellApplication {
    name = "hypr-shot";
    runtimeInputs = with pkgs; [
      coreutils
      grim
      libnotify
      satty
      slurp
      wl-clipboard
    ];
    text = builtins.readFile ../hypr/shot.sh;
  };

  powerMenu = pkgs.writeShellApplication {
    name = "desktop-power-menu";
    runtimeInputs = with pkgs; [
      hyprland
      hyprlock
      rofi
      systemd
      uwsm
    ];
    text = builtins.readFile ../waybar/power.sh;
  };

  keybindHelp = pkgs.writeShellApplication {
    name = "hypr-keybinds";
    runtimeInputs = with pkgs; [
      hyprland
      jq
      rofi
      util-linux
    ];
    text = builtins.readFile ../hypr/keybinds.sh;
  };

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
        printf '{"text":"notifications off","class":"disabled"}\n'
      else
        printf '{"text":"notifications","class":"enabled"}\n'
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
    ignis
    keybindHelp
    libnotify
    mako
    notificationStatus
    playerctl
    powerMenu
    rofi
    rofi-power-menu
    satty
    screenshot
    slurp
    swayosd
    waybar
    wl-clipboard
  ];

  systemd.user.services.ignis-shortcuts = {
    Unit = {
      Description = "Ignis desktop shortcut widget";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
    };
    Service = {
      Environment = "PATH=${lib.makeBinPath [ keybindHelp ]}";
      ExecStart = "${pkgs.bash}/bin/bash ${ignis}/bin/ignis init";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

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
  xdg.configFile."hypr/theme.lua".text = ''
    return {
      wallpaper = "${colors.wallpaper}",
      bg = "${colors.background}",
      surface = "${colors.surface}",
      border = "${colors.border}",
      blue = "${colors.accent}",
      shadow = "${colors.shadow}",
    }
  '';
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
        blur_passes = 1
        blur_size = 3
        color = rgb(${colors.background})
      }

      label {
        monitor =
        text = cmd[update:1000] date +"%H:%M"
        color = rgb(${colors.foreground})
        font_family = ${theme.fonts.sans}
        font_size = 72
        position = 0, 100
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:60000] date +"%A, %d %B"
        color = rgb(${colors.muted})
        font_family = ${theme.fonts.sans}
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
        outer_color = rgb(${colors.border})
        inner_color = rgb(${colors.background})
        font_color = rgb(${colors.foreground})
        fade_on_empty = false
        placeholder_text = <span foreground="##${colors.muted}">Password</span>
        check_color = rgb(${colors.accent})
        fail_color = rgb(${colors.critical})
        position = 0, -45
        halign = center
        valign = center
      }
    '';
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

  xdg.configFile."rofi/config.rasi".source = ../rofi/config.rasi;
  xdg.configFile."rofi/marble.rasi".source = renderTheme ../rofi/marble.rasi;
  xdg.configFile."rofi/keybinds.rasi".source = renderTheme ../rofi/keybinds.rasi;

  xdg.configFile."waybar/config.jsonc".source = ../waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = renderTheme ../waybar/style.css;

  xdg.configFile."swayosd/style.css".source = renderTheme ../swayosd/style.css;

  xdg.configFile."ignis/config.py".source = ../ignis/config.py;
  xdg.configFile."ignis/style.scss".source = renderTheme ../ignis/style.scss;

  xdg.configFile."mako/config".text = ''
    font=${theme.fonts.sans} 12
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

    background-color=#${colors.background}
    text-color=#${colors.foreground}
    border-color=#${colors.border}
    progress-color=over #${colors.border}

    [urgency=low]
    default-timeout=3000
    border-color=#${colors.border}

    [urgency=critical]
    default-timeout=0
    border-color=#${colors.critical}

    [mode=do-not-disturb]
    invisible=1
  '';

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
