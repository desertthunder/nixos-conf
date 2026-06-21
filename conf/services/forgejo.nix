{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.desert.services.gitForge;
  customDir = "/var/lib/forgejo/custom";
  customSource = ./forgejo/custom;
in
{
  options.desert.services.gitForge = {
    enable = lib.mkEnableOption "Forgejo git forge";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "git.desertthunder.dev";
      description = "Public hostname for the Forgejo web interface.";
    };

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 3030;
      description = "Local Forgejo HTTP port.";
    };

    sshDomain = lib.mkOption {
      type = lib.types.str;
      default = "nix-baxcalibur";
      description = "Hostname advertised for Forgejo SSH clone URLs.";
    };

    cloudflareTunnel = {
      enable = lib.mkEnableOption "Cloudflare Tunnel ingress for Forgejo";

      tunnelId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Cloudflare Tunnel UUID.";
      };

      credentialsSecret = lib.mkOption {
        type = lib.types.str;
        default = "cloudflare_git_forge_tunnel_credentials";
        description = "SOPS secret containing the Cloudflare Tunnel credentials JSON.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.cloudflareTunnel.enable -> cfg.cloudflareTunnel.tunnelId != "";
        message = "desert.services.gitForge.cloudflareTunnel.tunnelId must be set when the tunnel is enabled.";
      }
    ];

    environment.systemPackages = with pkgs; [
      cloudflared
      forgejo
      git-lfs
    ];

    services.forgejo = {
      enable = true;
      stateDir = "/var/lib/forgejo";
      customDir = customDir;

      database = {
        type = "postgres";
        name = "forgejo";
        user = "forgejo";
        createDatabase = true;
      };

      lfs = {
        enable = true;
        contentDir = "/var/lib/forgejo/data/lfs";
      };

      dump = {
        enable = true;
        interval = "04:31";
        type = "tar.zst";
        backupDir = "/var/lib/forgejo/dump";
        age = "4w";
      };

      settings = {
        DEFAULT = {
          APP_NAME = "Owais' Code Forge";
          APP_SLOGAN = "";
          RUN_MODE = "prod";
        };

        repository = {
          DEFAULT_PRIVATE = "private";
          DEFAULT_PUSH_CREATE_PRIVATE = true;
          DISABLE_HTTP_GIT = false;
          ENABLE_PUSH_CREATE_USER = false;
          ENABLE_PUSH_CREATE_ORG = false;
        };

        server = {
          PROTOCOL = "http";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = cfg.httpPort;
          DOMAIN = cfg.domain;
          ROOT_URL = "https://${cfg.domain}/";
          DISABLE_SSH = false;
          START_SSH_SERVER = false;
          SSH_DOMAIN = cfg.sshDomain;
          SSH_PORT = 22;
          LANDING_PAGE = "home";
        };

        service = {
          DISABLE_REGISTRATION = true;
          REQUIRE_SIGNIN_VIEW = false;
          ENABLE_NOTIFY_MAIL = false;
          NO_REPLY_ADDRESS = "noreply.${cfg.domain}";
        };

        openid = {
          ENABLE_OPENID_SIGNIN = false;
          ENABLE_OPENID_SIGNUP = false;
        };

        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = false;
        };

        session = {
          COOKIE_SECURE = true;
        };

        ui = {
          DEFAULT_THEME = "marble";
          THEMES = "marble,forgejo-auto,forgejo-light,forgejo-dark,gitea-auto,gitea-light,gitea-dark";
          SHOW_USER_EMAIL = false;
          ONLY_SHOW_RELEVANT_REPOS = true;
        };

        "ui.meta" = {
          AUTHOR = "Desert Thunder";
          DESCRIPTION = "Desert Thunder (Owais)'s Code Forge.";
          KEYWORDS = "git,forge,forgejo,nixos";
        };

        actions = {
          ENABLED = false;
        };

        packages = {
          ENABLED = false;
        };

        "repository.upload" = {
          ENABLED = true;
          FILE_MAX_SIZE = 50;
          MAX_FILES = 10;
        };

        security = {
          MIN_PASSWORD_LENGTH = 12;
          PASSWORD_HASH_ALGO = "pbkdf2_hi";
        };

        log = {
          LEVEL = "Info";
        };
      };
    };

    system.activationScripts.forgejoCustomAssets = lib.stringAfter [ "users" ] ''
      install -d -m 0750 -o forgejo -g forgejo ${customDir}
      ${pkgs.rsync}/bin/rsync -a --delete --chown=forgejo:forgejo ${customSource}/public/ ${customDir}/public/
      ${pkgs.rsync}/bin/rsync -a --delete --chown=forgejo:forgejo ${customSource}/templates/ ${customDir}/templates/
      chmod -R u=rwX,g=rX,o= ${customDir}/public ${customDir}/templates
    '';

    services.cloudflared = lib.mkIf cfg.cloudflareTunnel.enable {
      enable = true;
      tunnels.${cfg.cloudflareTunnel.tunnelId} = {
        credentialsFile = config.sops.secrets.${cfg.cloudflareTunnel.credentialsSecret}.path;
        default = "http_status:404";
        ingress.${cfg.domain}.service = "http://127.0.0.1:${toString cfg.httpPort}";
      };
    };

    sops.secrets = lib.mkIf cfg.cloudflareTunnel.enable {
      ${cfg.cloudflareTunnel.credentialsSecret} = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
  };
}
