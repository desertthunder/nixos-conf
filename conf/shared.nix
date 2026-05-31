{
  nixos =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.networkmanager.enable = true;

      time.timeZone = "America/Chicago";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      systemd.services.display-manager.restartIfChanged = false;
      systemd.services.display-manager.stopIfChanged = false;
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      services.printing.enable = true;
      services.openssh.enable = true;

      programs.zsh.enable = true;

      users.users.owais = {
        isNormalUser = true;
        description = "Owais";
        extraGroups = [
          "networkmanager"
          "wheel"
          "kvm"
        ];
        shell = pkgs.zsh;
        packages = with pkgs; [ ];
      };

      fonts = {
        fontconfig.enable = true;
        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
          nerd-fonts.commit-mono
          nerd-fonts.hack
          nerd-fonts.monaspace
          nerd-fonts._0xproto
          nerd-fonts.im-writing
          maple-mono.NF
          comic-mono
          open-sans
          inter
          noto-fonts
          ubuntu-classic
          fira-mono
          jetbrains-mono
        ];
      };

      programs.firefox.enable = true;
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          glibc
          stdenv.cc.cc.lib
        ];
      };

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.android_sdk.accept_license = true;

      environment.systemPackages = with pkgs; [
        vim
        git
        wget
        curl
        vscode
        neovim
        zsh
        nixfmt
        delta
      ];

      system.stateVersion = "25.11";
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      sops = {
        defaultSopsFile = ./secrets/owais.yaml;
        age.keyFile = "/var/lib/sops-nix/key.txt";

        secrets = {
          keys_gh = {
            owner = "owais";
            group = "users";
            mode = "0600";
          };
          keys_codeberg = {
            owner = "owais";
            group = "users";
            mode = "0600";
          };
          keys_tangled = {
            owner = "owais";
            group = "users";
            mode = "0600";
          };
        };
      };
    };

  home =
    {
      config,
      pkgs,
      lib,
      inputs,
      neovim-config,
      ...
    }:
    let
      elixir-ls-bin = pkgs.runCommand "elixir-ls-bin" { } ''
        mkdir -p $out/bin
        ln -s ${pkgs.elixir-ls}/bin/* $out/bin/
      '';
    in
    {
      home.username = "owais";
      home.homeDirectory = "/home/owais";

      xresources.properties = {
        "Xcursor.size" = 16;
        "Xft.dpi" = 172;
      };

      # GNOME settings (gsettings/dconf)
      dconf.settings = {
        # Ensure the power menu includes "Log Out…".
        "org/gnome/desktop/lockdown" = {
          disable-log-out = false;
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty" = {
          name = "Ghostty";
          command = "ghostty";
          binding = "<Control><Alt>t";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij" = {
          name = "Ghostty (zellij)";
          command = "ghostty -e zellij";
          binding = "<Super>z";
        };
      };

      home.packages = with pkgs; [
        shellcheck
        shfmt
        fastfetch
        ranger
        bat
        dust
        zip
        xz
        unzip
        p7zip
        ripgrep
        fd
        wl-clipboard
        xclip
        jq
        yq-go
        hurl
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
        charm-freeze
        glow
        vhs
        gum
        asciinema
        btop
        oh-my-zsh
        oh-my-posh
        pi-coding-agent
        codex
        nodejs_24
        go
        gopls
        gotools
        elixir
        elixir-ls-bin
        gleam
        dotnet-sdk_9
        nil
        lua-language-server
        rustc
        cargo
        wasm-pack
        rustfmt
        clippy
        rust-analyzer
        clang-tools
        bash-language-server
        typescript
        typescript-language-server
        stylua
        tree-sitter
        pnpm
        dprint
        eslint_d
        flutter
        android-studio
        android-tools
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
        typst
        whisper-cpp
        ffmpeg
        stdenv.cc
        gnumake
        pkg-config
        sqlite
        yt-dlp
        iotop
        iftop
        strace
        ltrace
        lsof
        sysstat
        lm_sensors
        ethtool
        pciutils
        usbutils
        rofi
        gnome-tweaks
        gnome-extension-manager
        google-chrome
        spotify
        zathura
        zathuraPkgs.zathura_pdf_poppler
      ];

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings."*".AddKeysToAgent = "no";
        extraConfig = ''
          Host github.com
            HostName github.com
            User git
            IdentityFile /run/secrets/keys_gh
            IdentitiesOnly yes

          Host codeberg.org
            HostName codeberg.org
            User git
            IdentityFile /run/secrets/keys_codeberg
            IdentitiesOnly yes

          Host tangled.sh
            HostName tangled.org
            User git
            IdentityFile /run/secrets/keys_tangled
            IdentitiesOnly yes
        '';
      };

      programs.zathura = {
        enable = true;
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
          rebuild = "sudo nixos-rebuild switch --flake ~/Projects/nixos-conf#$(hostname)";
          switch = "sudo nixos-rebuild switch --flake ~/Projects/nixos-conf#$(hostname)";
          update = "sudo nixos-rebuild switch --flake ~/Projects/nixos-conf#$(hostname)";
          nboot = "sudo nixos-rebuild boot --flake ~/Projects/nixos-conf#$(hostname)";
          tbuild = "sudo nixos-rebuild test --flake ~/Projects/nixos-conf#$(hostname)";
        };
        initContent = ''
          PATH=$HOME/.local/bin:$PATH
          PATH="$HOME/.cargo/bin:$PATH"
          export PATH="$HOME/go/bin:$PATH"
        '';
      };

      programs.git = {
        enable = true;
        settings.user.name = "Owais Jamil";
        settings.user.email = "desertthunder.dev@gmail.com";
        ignores = [
          ".DS_Store"
          "Thumbs.db"
          "*~"
          "*.swp"
          "*.swo"
          ".env"
          ".env.*"
          "!.env.example"
          ".direnv/"
          ".devenv/"
          "result"
          "result-*"
          ".sandbox/"
          "AGENTS.md"
          "CLAUDE.md"
        ];
      };

      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
        withPython3 = true;
        withRuby = true;
      };
      home.file.".config/nvim" = {
        source = neovim-config;
        recursive = true;
      };

      programs.oh-my-posh = {
        enable = true;
        settings = builtins.fromJSON (builtins.readFile ./modules/omp.json);
      };
      home.file.".config/zellij" = {
        source = ./modules/zellij;
        recursive = true;
      };
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

      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        installBatSyntax = true;
        installVimSyntax = true;
        settings = {
          font-family = "JetBrainsMono Nerd Font Propo";
          font-style = "SemiBold";
          font-size = 16;
          window-padding-x = 8;
          window-padding-y = 8;
          background = "1b1b1b";
          foreground = "ffffff";
          cursor-color = "78a9ff";
          cursor-text = "161616";
          palette = [
            "0=#161616"
            "1=#ee5396"
            "2=#42be65"
            "3=#ff7eb6"
            "4=#33b1ff"
            "5=#be95ff"
            "6=#3ddbd9"
            "7=#ffffff"
            "8=#525252"
            "9=#ee5396"
            "10=#42be65"
            "11=#ff7eb6"
            "12=#33b1ff"
            "13=#be95ff"
            "14=#3ddbd9"
            "15=#ffffff"
          ];
          command = "/run/current-system/sw/bin/zsh --login";
          shell-integration = "zsh";
          mouse-hide-while-typing = true;
          copy-on-select = false;
          confirm-close-surface = false;
        };
      };

      home.stateVersion = "25.11";
    };
}
