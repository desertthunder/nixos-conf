{
  inputs,
  ...
}:

let
  theme = import ./desktop-theme.nix;
  colors = theme.colors;
  wallpaperDir = ../wallpapers;
  wallpaper = ../wallpapers/wall00.png;

  noctaliaSettings = {
    shell = {
      corner_radius_scale = 1.0;
      font_family = theme.fonts.sans;
      setup_wizard_enabled = false;
      polkit_agent = true;
      launch_apps_as_systemd_services = true;
      clipboard_enabled = true;
      clipboard_confirm_clear_history = true;
      animation = {
        enabled = true;
        speed = 1.0;
      };
      panel = {
        transparency_mode = "solid";
        borders = true;
        shadow = false;
        launcher_placement = "floating";
        launcher_position = "center";
        clipboard_placement = "floating";
        clipboard_position = "center";
        control_center_placement = "attached";
        wallpaper_placement = "attached";
        session_placement = "attached";
      };
      screenshot = {
        save_to_file = true;
        directory = "~/Pictures/Screenshots";
        filename_pattern = "screenshot_%Y%m%d_%H%M%S";
        copy_to_clipboard = true;
        freeze_screen = true;
        show_cursor = false;
        annotate = true;
        close_on_copy = true;
      };
    };

    wallpaper = {
      enabled = true;
      directory = toString wallpaperDir;
      fill_mode = "crop";
      transition = [ "fade" ];
      transition_duration = 500;
      default.path = toString wallpaper;
      automation.enabled = false;
    };

    theme = {
      mode = "dark";
      source = "builtin";
      builtin = "Eldritch";
      # To restore the custom palette:
      # source = "custom";
      # custom_palette = "Haxorus";
      pure_black_dark = false;
      templates = {
        enable_builtin_templates = false;
        enable_community_templates = false;
      };
    };

    notification = {
      enable_daemon = true;
      keep_dismissed_in_history = true;
      background_opacity = 1.0;
      offset_x = 8;
      offset_y = 8;
    };

    osd = {
      position = "top_center";
      orientation = "horizontal";
      background_opacity = 1.0;
      offset_x = 8;
      offset_y = 8;
    };

    lockscreen = {
      enabled = true;
      lock_before_suspend = true;
      fingerprint = true;
      blurred_desktop = false;
      wallpaper = toString wallpaper;
      blur_intensity = 0.0;
      tint_intensity = 0.3;
    };

    idle = {
      behavior_order = [
        "lock"
        "screen-off"
        "suspend"
      ];
      behavior = {
        lock = {
          timeout = 300;
          action = "lock";
          enabled = true;
        };
        screen-off = {
          timeout = 330;
          action = "screen_off";
          enabled = true;
        };
        suspend = {
          timeout = 900;
          action = "lock_and_suspend";
          enabled = true;
        };
      };
    };

    bar.main = {
      position = "top";
      thickness = 34;
      background_opacity = 1.0;
      radius = 8;
      margin_ends = 8;
      margin_edge = 8;
      padding = 8;
      widget_spacing = 6;
      shadow = false;
      reserve_space = true;
      start = [
        "launcher"
        "workspaces"
      ];
      center = [ "media" ];
      end = [
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "battery"
        "caffeine"
        "notifications"
        "tray"
        "clock"
        "control-center"
        "session"
      ];
    };

    widget.clock = {
      format = "{:%H:%M}";
      tooltip_format = "{:%Y-%m-%d}";
    };
    widget.media = {
      max_length = 60;
    };

    control_center = {
      sidebar = "compact";
      show_session_button = true;
      hidden_tabs = [
        "weather"
        "calendar"
        "screen-time"
      ];
      shortcuts = [
        { type = "wifi"; }
        { type = "bluetooth"; }
        { type = "notification"; }
        { type = "wallpaper"; }
        { type = "session"; }
      ];
    };

    dock.enabled = false;
    desktop_widgets.enabled = false;
  };

  /*
    haxorusPalette = {
      dark = {
        mPrimary = "#${colors.accent}";
        mOnPrimary = "#${colors.background}";
        mSecondary = "#${colors.warning}";
        mOnSecondary = "#${colors.background}";
        mTertiary = "#${colors.critical}";
        mOnTertiary = "#${colors.background}";
        mError = "#${colors.critical}";
        mOnError = "#${colors.background}";
        mSurface = "#${colors.background}";
        mOnSurface = "#${colors.foreground}";
        mSurfaceVariant = "#${colors.surface}";
        mOnSurfaceVariant = "#${colors.muted}";
        mOutline = "#${colors.border}";
        mShadow = "#000000";
        mHover = "#${colors.border}";
        mOnHover = "#${colors.foreground}";
      };
    };
  */
in
{
  imports = [ inputs.noctalia.nixosModules.default ];

  programs.noctalia = {
    enable = true;
    systemd = {
      enable = true;
      target = "umbriel-session.target";
    };
  };
  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;

  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GNOME enables IBus by default, but Haxorus only uses the US XKB layout.
  i18n.inputMethod.enable = false;

  systemd.services.display-manager.restartIfChanged = false;
  systemd.services.display-manager.stopIfChanged = false;

  home-manager.sharedModules = [
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        settings = noctaliaSettings;
        # customPalettes.Haxorus = haxorusPalette;
      };
    }
  ];
}
