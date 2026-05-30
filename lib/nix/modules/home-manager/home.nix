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
      shellcheck
      shfmt

      neofetch
      ranger
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

      just

      # Charm stuff
      charm-freeze
      glow
      vhs
      gum

      asciinema

      btop

      oh-my-zsh
      oh-my-posh

      # Development tools and language toolchains
      nodejs_24
      go_1_24
      gopls
      dotnet-sdk_9
      nil # nix language server
      pnpm
      dprint

      # Flutter mobile development
      flutter
      jdk17

      uv
      (python313.withPackages (
        ps: with ps; [
          pip
          ipython
          requests
        ]
      ))
      go-task
      mdbook

      bun
      markdownlint-cli
      markdownlint-cli2
      shellcheck
      shfmt
      typst
      whisper-cpp

      ffmpeg

      stdenv.cc
      pkg-config
    ]
    ++ lib.optionals stdenv.isLinux [
      yt-dlp
      iotop
      iftop

      claude-code
      codex

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

  programs.zsh.initContent = builtins.readFile "${root}/lib/dotfiles/zsh/.zshrc";

  home.sessionVariables = {
    npm_config_prefix = "$HOME/.npm-global";
  };

  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.local/bin"
  ];

  home.activation.installPiCodingAgent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export npm_config_prefix="$HOME/.npm-global"
    export PATH="$HOME/.npm-global/bin:${pkgs.nodejs_24}/bin:$PATH"
    mkdir -p "$HOME/.npm-global"

    if ! command -v pi >/dev/null 2>&1; then
      echo "Installing pi coding agent with npm"
      ${pkgs.nodejs_24}/bin/npm install --global @earendil-works/pi-coding-agent
    fi
  '';

  home.file.".gitconfig".source = "${root}/lib/dotfiles/git/.gitconfig";

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

  home.file.".config/oh-my-posh/theme.json".source = "${root}/lib/dotfiles/oh-my-posh/.config/oh-my-posh/theme.json";

  home.file.".config/zellij" = {
    source = "${root}/lib/dotfiles/zellij/.config/zellij";
    recursive = true;
  };

  home.file.".config/ripgrep/config".source = "${root}/lib/dotfiles/ripgrep/.config/ripgrep/config";

  home.file.".config/ghostty/config".source = "${root}/lib/dotfiles/ghostty/.config/ghostty/config";

  # This value determines the home Manager release that your configuration is compatible with.
  # This helps avoid breakage when a new home Manager release introduces backwards incompatible changes.
  #
  # You can update home Manager without changing this value.
  # See the home Manager release notes for a list of state version changes in each release.
  home.stateVersion = "25.11";
}
