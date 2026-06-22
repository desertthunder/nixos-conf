{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.desert.services.tangledKnot;
in
{
  imports = [
    inputs.tangled.nixosModules.knot
  ];

  options.desert.services.tangledKnot = {
    enable = lib.mkEnableOption "Tangled knot";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "knot.desertthunder.dev";
      description = "Public hostname for the Tangled knot.";
    };

    ownerDid = lib.mkOption {
      type = lib.types.str;
      default = "did:plc:xg2vq45muivyy3xwatcehspu";
      description = "ATproto DID that owns this knot.";
    };

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 5555;
      description = "Local Tangled knot HTTP port.";
    };

    internalPort = lib.mkOption {
      type = lib.types.port;
      default = 5444;
      description = "Local Tangled knot internal API port.";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/tangled-knot";
      description = "Tangled knot state directory.";
    };

    secureMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Tangled knot secure mode for isolated git subprocesses.";
    };

    cloudflareTunnel = {
      enable = lib.mkEnableOption "Cloudflare Tunnel ingress for the Tangled knot";

      tunnelId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Cloudflare Tunnel UUID.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.ownerDid != "";
        message = "desert.services.tangledKnot.ownerDid must be set to the owner's ATproto DID.";
      }
      {
        assertion = cfg.cloudflareTunnel.enable -> cfg.cloudflareTunnel.tunnelId != "";
        message = "desert.services.tangledKnot.cloudflareTunnel.tunnelId must be set when the tunnel is enabled.";
      }
    ];

    services.tangled.knot = {
      enable = true;
      package = inputs.tangled.packages.${pkgs.stdenv.hostPlatform.system}.knot-unwrapped;
      appviewEndpoint = "https://tangled.org";
      gitUser = "git";
      openFirewall = true;
      stateDir = cfg.stateDir;
      motd = "Welcome to Owais' knot.\n";

      repo.scanPath = "${cfg.stateDir}/repositories";

      git = {
        userName = "Owais";
        userEmail = "noreply@${cfg.domain}";
      };

      server = {
        owner = cfg.ownerDid;
        hostname = cfg.domain;
        listenAddr = "127.0.0.1:${toString cfg.httpPort}";
        internalListenAddr = "127.0.0.1:${toString cfg.internalPort}";
        secureMode = cfg.secureMode;
      };
    };

    systemd.services.knot.preStart = lib.mkBefore ''
      chown -R git:git ${cfg.stateDir}
      chmod 0700 ${cfg.stateDir}
    '';

    services.cloudflared = lib.mkIf cfg.cloudflareTunnel.enable {
      enable = true;
      tunnels.${cfg.cloudflareTunnel.tunnelId} = {
        default = "http_status:404";
        ingress.${cfg.domain}.service = "http://127.0.0.1:${toString cfg.httpPort}";
      };
    };
  };
}
