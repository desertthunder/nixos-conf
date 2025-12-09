{
  config,
  pkgs,
  lib,
  inputs,
  neovim-config,
  root,
  ...
}:

{
  imports = [
    ./ssh-config.nix
    ./sops-hm.nix
  ];
  home.username = "owais";
  home.homeDirectory = "/home/owais";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.packages =
    with pkgs;
    # Cross-platform packages
    [
      neofetch
      yazi
      bat
      dust # du made with rust

      zip
      xz
      unzip
      p7zip

      ripgrep
      jq
      yq-go
      fzf
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg

      nix-output-monitor

      zellij

      # Charm stuff
      charm-freeze
      glow
      vhs

      asciinema

      btop

      oh-my-zsh
      oh-my-posh

      # Development tools and language toolchains
      rustup
      nodejs_24
      go_1_24
      gopls
      python313
      dotnet-sdk
      nil # nix language server

      mdbook

      claude-code
      codex

      stdenv.cc
      pkg-config
    ]
    ++ lib.optionals stdenv.isLinux [
      iotop
      iftop

      # System call monitoring
      strace
      ltrace
      lsof

      # Hardware monitoring
      sysstat
      lm_sensors
      ethtool
      pciutils
      usbutils

      # X11 applications
      rofi
      zathura
      zathuraPkgs.zathura_pdf_poppler
    ];

  programs.zathura = {
    enable = pkgs.stdenv.isLinux;

    options = {
      "selection-clipboard" = "clipboard";

      "default-fg" = "rgba(205,214,244,1)";
      "default-bg" = "rgba(30,30,46,1)";

      "completion-bg" = "rgba(49,50,68,1)";
      "completion-fg" = "rgba(205,214,244,1)";
      "completion-highlight-bg" = "rgba(203,166,247,1)";
      "completion-highlight-fg" = "rgba(30,30,46,1)";
      "completion-group-bg" = "rgba(24,24,37,1)";
      "completion-group-fg" = "rgba(205,214,244,1)";

      "statusbar-fg" = "rgba(205,214,244,1)";
      "statusbar-bg" = "rgba(17,17,27,1)";
      "inputbar-fg" = "rgba(205,214,244,1)";
      "inputbar-bg" = "rgba(30,30,46,1)";

      "notification-bg" = "rgba(30,30,46,1)";
      "notification-fg" = "rgba(205,214,244,1)";
      "notification-error-bg" = "rgba(30,30,46,1)";
      "notification-error-fg" = "rgba(243,139,168,1)";
      "notification-warning-bg" = "rgba(30,30,46,1)";
      "notification-warning-fg" = "rgba(249,226,175,1)";

      "recolor" = false;
      "recolor-lightcolor" = "rgba(30,30,46,1)";
      "recolor-darkcolor" = "rgba(205,214,244,1)";

      "index-fg" = "rgba(205,214,244,1)";
      "index-bg" = "rgba(30,30,46,1)";
      "index-active-fg" = "rgba(205,214,244,1)";
      "index-active-bg" = "rgba(49,50,68,1)";

      "render-loading-bg" = "rgba(30,30,46,1)";
      "render-loading-fg" = "rgba(205,214,244,1)";

      "highlight-color" = "rgba(147,153,178,0.3)";
      "highlight-fg" = "rgba(205,214,244,1)";
      "highlight-active-color" = "rgba(203,166,247,0.3)";

      "page-padding" = 0;
    };

    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      T = "toggle_page_mode";
      J = "scroll full-down";
      K = "scroll full-up";
      r = "reload";
      R = "rotate";
      A = "zoom in";
      D = "zoom out";
      i = "recolor";
      p = "print";
      b = "toggle_statusbar";
    };

    extraConfig = ''

    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
      ];
      theme = "agnoster";
    };

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
  };

  programs.git = {
    enable = true;
    userName = "Owais Jamil";
    userEmail = "desertthunder.dev@gmail.com";
  };

  programs.alacritty = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Propo";
          style = "SemiBold";
        };
        size = 15;
      };
      env = {
        TERM = "xterm-256color";
      };
      window = {
        padding = {
          x = 8;
          y = 8;
        };
      };
      colors = {
        primary = {
          background = "#1b1b1b";
          foreground = "#ffffff";
        };
        cursor = {
          text = "#161616";
          cursor = "#78a9ff";
        };
        normal = {
          black = "#161616";
          red = "#ee5396";
          green = "#42be65";
          yellow = "#ff7eb6";
          blue = "#33b1ff";
          magenta = "#be95ff";
          cyan = "#3ddbd9";
          white = "#ffffff";
        };
        bright = {
          black = "#525252";
          red = "#ee5396";
          green = "#42be65";
          yellow = "#ff7eb6";
          blue = "#33b1ff";
          magenta = "#be95ff";
          cyan = "#3ddbd9";
          white = "#ffffff";
        };
      };

      terminal.shell = {
        program = "/run/current-system/sw/bin/zsh";
        args = [ "-l" ];
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  home.file.".config/nvim" = {
    source = neovim-config;
    recursive = true;
  };

  programs.oh-my-posh = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile "${root}/modules/omp.json");
  };

  home.file.".config/zellij" = {
    source = "${root}/modules/zellij";
    recursive = true;
  };

  # See: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
  home.file.".config/ripgrep/config".text = ''
    --line-number
    --smart-case
    --max-columns=120
    --max-columns-preview

    --type-add=nix:*.nix

    --glob=!.git/*
    --glob=!**/node_modules/**
    --glob=!**/target/**
    --glob=!**/.build/**
  '';

  home.file.".config/ghostty/config".text = ''
    # Font configuration
    font-style = SemiBold
    font-size = 16

    # Window settings
    window-padding-x = 8
    window-padding-y = 8

    # Color scheme
    background = 1b1b1b
    foreground = ffffff

    # Cursor colors
    cursor-color = 78a9ff
    cursor-text = 161616

    # Normal colors
    palette = 0=#161616
    palette = 1=#ee5396
    palette = 2=#42be65
    palette = 3=#ff7eb6
    palette = 4=#33b1ff
    palette = 5=#be95ff
    palette = 6=#3ddbd9
    palette = 7=#ffffff

    # Bright colors
    palette = 8=#525252
    palette = 9=#ee5396
    palette = 10=#42be65
    palette = 11=#ff7eb6
    palette = 12=#33b1ff
    palette = 13=#be95ff
    palette = 14=#3ddbd9
    palette = 15=#ffffff

    shell-integration = zsh

    mouse-hide-while-typing = true
    copy-on-select = false
    confirm-close-surface = false
  '';

  # This value determines the home Manager release that your configuration is compatible with.
  # This helps avoid breakage when a new home Manager release introduces backwards incompatible changes.
  #
  # You can update home Manager without changing this value.
  # See the home Manager release notes for a list of state version changes in each release.
  home.stateVersion = "25.05";
}
