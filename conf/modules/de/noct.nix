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

    desktop_widgets = {
      enabled = true;
      schema_version = 2;
      widget_order = [ "shortcuts" ];
      widget.shortcuts = {
        type = "label";
        output = "eDP-1";
        # eDP-1 is 1600x900 logical pixels at the configured 1.2 scale.
        cx = 1380.0;
        cy = 730.0;
        box_width = 360.0;
        box_height = 0.0;
        settings = {
          title = "HAXORUS";
          description = ''
            Terminal     Super + Return
            Launcher     Super + Space
            Browser      Super + B
            Files        Super + E
            Clipboard    Super + V
            Lock         Super + Shift + L
            Shortcuts    Super + ?
          '';
          color = "on_surface";
          shadow = true;
          background = true;
          background_color = "surface";
          background_opacity = 0.9;
          background_radius = 8.0;
        };
      };
    };
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

  workspaceBinds = builtins.listToAttrs (
    map (
      number:
      let
        key = if number == 10 then "0" else toString number;
      in
      {
        name = "Mod+${key}";
        value = "workspace-switch:${toString number}";
      }
    ) (builtins.genList (index: index + 1) 10)
    ++ map (
      number:
      let
        key = if number == 10 then "0" else toString number;
      in
      {
        name = "Mod+Shift+${key}";
        value = "window-move-to-workspace:${toString number}";
      }
    ) (builtins.genList (index: index + 1) 10)
  );

  umbrielSettings = {
    general = {
      autostart = [ ];
      mod_key = "Super";
      xwayland = true;
      show_cheatsheet = false;
      focus_on_activate = false;
    };

    environment = {
      NIXOS_OZONE_WL = "1";
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "24";
      TERMINAL = "ghostty";
    };

    output.eDP-1 = {
      position = [
        0
        0
      ];
      scale = 1.2;
      workspaces = 10;
      workspace_axis = "horizontal";
    };

    workspaces.back_and_forth = true;

    colors = {
      background = "#${colors.background}FF";
      text_primary = "#${colors.foreground}FF";
      text_muted = "#${colors.muted}FF";
      accent_primary = "#${colors.accent}FF";
      accent_secondary = "#${colors.warning}FF";
      warning = "#${colors.warning}FF";
      error = "#${colors.critical}FF";
      backdrop = "#${colors.wallpaper}FF";
      shadow = "#00000044";
      border = {
        focused = "#${colors.accent}FF";
        unfocused = "#${colors.border}FF";
        scratchpad_focused = "#${colors.warning}FF";
        scratchpad_unfocused = "#${colors.border}FF";
        outer = "#${colors.background}FF";
      };
    };

    appearance = {
      prefer_no_csd = true;
      border_width = 1;
      outer_border_width = 0;
      corner_radius = 8;
      drag_opacity = 0.9;
      blur.enabled = false;
      shadow.enabled = false;
    };

    input = {
      middle_click_paste = true;
      keyboard.layout = "us";
      touchpad = {
        tap = true;
        natural_scroll = true;
        disable_while_typing = true;
      };
      mouse.sensitivity = 0.0;
      cursor = {
        theme = "Adwaita";
        size = 24;
        follows_focus = false;
        hide_when_typing = false;
      };
      focus.follows_mouse = true;
    };

    layout = {
      mode = "dwindle";
      gap = 4;
      width_presets = [
        0.333
        0.5
        0.667
        1.0
      ];
      dwindle.preserve_split = true;
    };

    keybinds = {
      "Mod+Return" = "spawn:ghostty";
      "Mod+Z" = "spawn:ghostty -e zellij";
      "Mod+B" = "spawn:zen-beta";
      "Mod+E" = "spawn:nautilus";
      "Mod+R" = "spawn:noctalia msg panel-toggle launcher";
      "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
      "Mod+P" = "spawn:noctalia msg panel-toggle launcher";
      "Mod+V" = "spawn:noctalia msg panel-toggle clipboard";
      "Mod+Shift+V" = "spawn:noctalia msg clipboard-clear";
      "Mod+N" = "spawn:noctalia msg notification-invoke-latest";
      "Mod+Shift+N" = "spawn:noctalia msg notification-dnd-toggle";
      "Mod+Shift+R" = "config-reload";
      "Mod+Shift+L" = "spawn:noctalia msg session lock";
      "Mod+Shift+Slash" = {
        action = "cheatsheet-toggle";
        repeat = false;
      };
      "Mod+Escape" = "spawn:noctalia msg panel-toggle session";

      "Mod+Q" = "window-close";
      "Mod+Shift+F" = "spawn:umbriel msg window-toggle-floating && umbriel msg window-center";
      "Mod+Shift+G" = "window-toggle-fullscreen";
      "Mod+Shift+H" = "window-toggle-maximize";
      "Mod+Shift+P" = "window-toggle-pinned";

      "Mod+Left" = "window-focus-left";
      "Mod+Right" = "window-focus-right";
      "Mod+Up" = "window-focus-up";
      "Mod+Down" = "window-focus-down";
      "Mod+H" = "window-focus-left";
      "Mod+J" = "window-focus-down";
      "Mod+K" = "window-focus-up";
      "Mod+L" = "window-focus-right";

      "Mod+Ctrl+H" = "window-modify-width:-0.1";
      "Mod+Ctrl+J" = "window-modify-height:0.1";
      "Mod+Ctrl+K" = "window-modify-height:-0.1";
      "Mod+Ctrl+L" = "window-modify-width:0.1";
      "Mod+Alt+H" = "column-move-left";
      "Mod+Alt+J" = "window-move-down";
      "Mod+Alt+K" = "window-move-up";
      "Mod+Alt+L" = "column-move-right";

      "Mod+S" = "scratchpad-toggle";
      "Mod+Shift+S" = "window-move-to-scratchpad";
      "Mod+WheelUp" = {
        action = "workspace-previous";
        cooldown_ms = 150;
      };
      "Mod+WheelDown" = {
        action = "workspace-next";
        cooldown_ms = 150;
      };

      "Print" = {
        action = "spawn:noctalia msg screenshot-region";
        repeat = false;
      };
      "Shift+Print" = {
        action = "spawn:noctalia msg screenshot-fullscreen";
        repeat = false;
      };

      "XF86AudioRaiseVolume" = {
        action = "spawn:noctalia msg volume-up";
        allow_when_locked = true;
      };
      "XF86AudioLowerVolume" = {
        action = "spawn:noctalia msg volume-down";
        allow_when_locked = true;
      };
      "XF86AudioMute" = {
        action = "spawn:noctalia msg volume-mute-toggle";
        allow_when_locked = true;
      };
      "XF86AudioMicMute" = {
        action = "spawn:noctalia msg microphone-mute-toggle";
        allow_when_locked = true;
      };
      "XF86MonBrightnessUp" = {
        action = "spawn:noctalia msg brightness-up 5";
        allow_when_locked = true;
      };
      "XF86MonBrightnessDown" = {
        action = "spawn:noctalia msg brightness-down 5";
        allow_when_locked = true;
      };
      "XF86AudioNext" = {
        action = "spawn:noctalia msg media next";
        allow_when_locked = true;
      };
      "XF86AudioPause" = {
        action = "spawn:noctalia msg media toggle";
        allow_when_locked = true;
      };
      "XF86AudioPlay" = {
        action = "spawn:noctalia msg media toggle";
        allow_when_locked = true;
      };
      "XF86AudioPrev" = {
        action = "spawn:noctalia msg media previous";
        allow_when_locked = true;
      };
    }
    // workspaceBinds;

    window_rule = [
      {
        match.is_focused = false;
        opacity = 0.97;
      }
      {
        match.app_id = "^dev[.]noctalia[.]Noctalia$";
        default_floating = true;
        default_size = [
          1020
          900
        ];
      }
      {
        match.app_id = "^dev[.]noctalia[.]UmbrielSharePicker$";
        default_floating = true;
        default_size = [
          800
          600
        ];
      }
      {
        match.app_id = "^(org[.]gnome[.]Calculator|org[.]gnome[.]Nautilus|org[.]pulseaudio[.]pavucontrol|pavucontrol|nm-connection-editor|org[.]gnome[.]Settings|xdg-desktop-portal.*)$";
        default_floating = true;
      }
      {
        match.title = "^(Picture-in-Picture|Picture in picture)$";
        default_floating = true;
        default_position = {
          x = 20;
          y = 20;
          anchor = "bottom_right";
        };
      }
    ];

    animation = {
      enabled = true;
      duration_ms = 200;
      curve = "easeout";
      windows_in = {
        enabled = true;
        duration_ms = 150;
        style = "popin";
        scale = 0.9;
      };
      windows_out = {
        enabled = true;
        duration_ms = 150;
        style = "fade";
      };
      windows_move.enabled = true;
      workspaces.enabled = true;
      overview.enabled = true;
      scratchpad = {
        enabled = true;
        dim = 0.3;
        blur = false;
      };
    };
  };
in
{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.umbriel.nixosModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd = {
      enable = true;
      target = "umbriel-session.target";
    };
  };
  programs.umbriel.enable = true;

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
      imports = [
        inputs.noctalia.homeModules.default
        inputs.umbriel.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
        settings = noctaliaSettings;
        # customPalettes.Haxorus = haxorusPalette;
      };

      programs.umbriel = {
        enable = true;
        settings = umbrielSettings;
      };
    }
  ];
}
