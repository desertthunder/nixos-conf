{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.desert.services.searxng;
  environmentFile = "/var/lib/searx/environment";
in
{
  options.desert.services.searxng = {
    enable = lib.mkEnableOption "local SearXNG search service";

    bindAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address SearXNG binds to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9090;
      description = "Local SearXNG HTTP port.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.searx = {
      enable = true;
      environmentFile = environmentFile;
      settings = {
        general = {
          debug = false;
          instance_name = "Haxorus Search";
        };

        search = {
          autocomplete = "duckduckgo";
          formats = [
            "html"
            "json"
            "rss"
          ];
        };

        server = {
          bind_address = cfg.bindAddress;
          port = cfg.port;
          secret_key = "$SEARX_SECRET_KEY";
          limiter = false;
          public_instance = false;
        };

        preferences.lock = [ ];
      };
    };

    systemd.services = {
      searx-secret = {
        description = "Generate the SearXNG secret";
        before = [ "searx-init.service" ];
        requiredBy = [ "searx-init.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StateDirectory = "searx";
          UMask = "0077";
        };
        script = ''
          if ! test -s ${environmentFile}; then
            secret="$(${pkgs.coreutils}/bin/head -c 32 /dev/urandom | ${pkgs.coreutils}/bin/base64 -w0)"
            printf 'SEARX_SECRET_KEY=%s\n' "$secret" > ${environmentFile}
          fi
          chown searx:searx ${environmentFile}
          chmod 0600 ${environmentFile}
        '';
      };

      searx-init = {
        requires = [ "searx-secret.service" ];
        after = [ "searx-secret.service" ];
      };
    };
  };
}
