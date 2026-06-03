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

      virtualisation.docker.enable = true;

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "owais" ];
        ensureUsers = [
          {
            name = "owais";
            ensureDBOwnership = true;
            ensureClauses = {
              createdb = true;
              createrole = true;
            };
          }
        ];
        authentication = ''
          local all all trust
          host all all 127.0.0.1/32 trust
          host all all ::1/128 trust
        '';
      };

      services.redis.servers."".enable = true;

      programs.zsh.enable = true;

      users.users.owais = {
        isNormalUser = true;
        description = "Owais";
        extraGroups = [
          "networkmanager"
          "wheel"
          "kvm"
          "docker"
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
          nerd-fonts.comic-shanns-mono
          nerd-fonts.martian-mono
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

      # TODO: Combine with programs.ssh into a secrets object/module
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

      editor-tool-pkgs = with pkgs; [
        bash-language-server
        clang-tools
        deno
        dprint
        elixir
        elixir-ls-bin
        eslint_d
        flutter
        gleam
        go
        gopls
        gotools
        lua-language-server
        nil
        nixd
        nixfmt
        nodejs_24
        rust-analyzer
        rustfmt
        shellcheck
        shfmt
        stylua
        typescript
        typescript-language-server
      ];

      # TODO: consider removing some of these
      #  some of these could be dev-tool-pkgs (hurl, jq, just, etc.)
      cli-tool-pkgs = with pkgs; [
        bat
        codex
        dust
        fastfetch
        fd
        file
        fzf
        gnupg
        hurl
        jq
        just
        nix-output-monitor
        oh-my-zsh
        pi-coding-agent
        ripgrep
        starship
        tree
        which
        wl-clipboard
        xclip
        yq-go
      ];

      archive-pkgs = with pkgs; [
        gnused
        gnutar
        gawk
        p7zip
        unzip
        xz
        zip
        zstd
      ];

      tui-pkgs = with pkgs; [
        asciinema
        btop
        charm-freeze
        glow
        gum
        vhs
        zellij
      ];

      dev-tool-pkgs = with pkgs; [
        android-tools
        android-studio
        bun
        cargo
        ctop
        dive
        clippy
        dotnet-sdk_9
        go-task
        harlequin
        jdk17
        lazydocker
        markdownlint-cli
        markdownlint-cli2
        mdbook
        pnpm
        rustc
        stdenv.cc
        gnumake
        tree-sitter
        typst
        uv
        wasm-pack
        (python313.withPackages (
          ps: with ps; [
            pip
            ipython
            requests
          ]
        ))
      ];

      sys-tool-pkgs = with pkgs; [
        ethtool
        iftop
        iotop
        lm_sensors
        lsof
        ltrace
        pciutils
        strace
        sysstat
        usbutils
      ];

      media-pkgs = with pkgs; [
        ffmpeg
        whisper-cpp
        yt-dlp
      ];

      gui-pkgs = with pkgs; [
        gnome-extension-manager
        gnome-tweaks
        google-chrome
        kora-icon-theme
        spotify
        zathura
        zathuraPkgs.zathura_pdf_poppler
        mpv
      ];

      text-editors = {
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

        /*
          Home Manager's Zed module reference:
          https://github.com/nix-community/home-manager/blob/master/modules/programs/zed-editor.nix
        */
        programs.zed-editor = {
          enable = true;
          extensions = [
            "basher"
            "dart"
            "deno"
            "elixir"
            "flutter-snippets"
            "gleam"
            "lua"
            "nix"
            "oxocarbon"
          ];
          extraPackages = editor-tool-pkgs;
          userSettings = {
            theme = "Oxocarbon Dark (Variant I)";
            vim_mode = true;
            ui_font_family = "Inter";
            ui_font_size = 18.0;
            buffer_font_family = "0xProto Nerd Font Propo";
            buffer_font_size = 18;
            terminal = {
              font_family = "MartianMono Nerd Font";
              font_size = 17;
            };
            tab_size = 2;
            hard_tabs = false;
            format_on_save = "on";
            telemetry = {
              diagnostics = false;
              metrics = false;
            };
            lsp.deno.settings.deno = {
              enable = true;
              lint = true;
            };
            toolbar = {
              breadcrumbs = false;
            };
          };
        };
      };
    in
    {
      imports = [
        text-editors
        inputs.catppuccin.homeModules.catppuccin
      ];

      home.username = "owais";
      home.homeDirectory = "/home/owais";
      xresources.properties = {
        "Xcursor.size" = 16;
        "Xft.dpi" = 172;
      };

      /**
        GNOME Settings
      */
      dconf.settings = {
        "org/gnome/desktop/lockdown" = {
          disable-log-out = false;
        };

        "org/gnome/desktop/interface" = {
          icon-theme = "kora";
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

      home.packages =
        editor-tool-pkgs
        ++ cli-tool-pkgs
        ++ archive-pkgs
        ++ tui-pkgs
        ++ dev-tool-pkgs
        ++ sys-tool-pkgs
        ++ media-pkgs
        ++ gui-pkgs;

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

      programs.bat = {
        enable = true;
        config = {
          style = "numbers,changes";
          paging = "auto";
          wrap = "never";
          pager = "less -FR";
        };
      };

      # TODO: dev tooling mod
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      catppuccin = {
        enable = true;
        autoEnable = false;
        flavor = "mocha";
        bat.enable = true;
        starship.enable = false;
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
          theme = "";
        };
        shellAliases = {
          ll = "ls -l";
          rebuild = "sudo nixos-rebuild switch --flake ~/Projects/nixos-conf#$(hostname)";
          switch = "sudo nixos-rebuild switch --flake ~/Projects/nixos-conf#$(hostname)";
          update = "sudo nixos-rebuild switch --flake ~/Projects/nixos-conf#$(hostname)";
          nboot = "sudo nixos-rebuild boot --flake ~/Projects/nixos-conf#$(hostname)";
          tbuild = "sudo nixos-rebuild test --flake ~/Projects/nixos-conf#$(hostname)";

          cat = "bat --paging=never --style=plain";
          less = "bat";
          preview = "bat --style=numbers,changes --color=always";

          zed = "zeditor";
          zedn = "zeditor --new";
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

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          format = lib.concatStrings [
            "$time"
            " [](blue) "
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_state"
            "$git_status"
            "$cmd_duration"
            "$line_break"
            "$python"
            "$character"
          ];

          directory = {
            style = "blue";
            substitutions = {
              "Documents" = "󰈙 ";
              "Downloads" = " ";
              "Music" = " ";
              "Pictures" = " ";
            };
          };

          character = {
            success_symbol = "[❯](purple)";
            error_symbol = "[❯](red)";
            vimcmd_symbol = "[❮](green)";
          };

          git_branch = {
            symbol = "";
            format = " [$symbol $branch]($style) ";
            style = "bright-black";
          };

          git_status = {
            format = "([[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style))";
            style = "cyan";
            conflicted = "";
            untracked = "";
            modified = "";
            staged = "";
            renamed = "";
            deleted = "";
            stashed = "≡";
          };

          git_state = {
            format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
            style = "bright-black";
          };

          cmd_duration = {
            format = "[$duration]($style) ";
            style = "yellow";
          };

          time = {
            disabled = false;
            time_format = "%R";
            style = "bright-black";
            format = "[ $time ]($style)";
          };
        };
      };

      home.file.".config/zellij" = {
        source = ./modules/zellij;
        recursive = true;
      };

      home.file.".pi/agent/AGENTS.md" = {
        source = ./agent/AGENTS.md;
        force = true;
      };

      home.file.".pi/agent/skills" = {
        source = ./agent/skills;
        recursive = true;
        force = true;
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
          font-family = "MartianMono Nerd Font";
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
