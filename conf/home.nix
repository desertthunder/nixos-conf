{
  config,
  pkgs,
  inputs,
  root,
  ...
}:

{
  home.username = "owais";
  home.homeDirectory = "/home/owais";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.packages = with pkgs; [
    neofetch
    yazi

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

    glow

    btop
    iotop
    iftop

    # system call monitoring
    strace
    ltrace
    lsof

    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    oh-my-zsh
    oh-my-posh

    rustup
    nodejs
    gopls
    mdbook

    claude-code
    codex

    rofi
    zathura
    asciinema

    stdenv.cc
    pkg-config
  ];

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
        "autosuggestions"
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
    enable = true;
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
    source = root + "/modules/nvim/.";
    recursive = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
