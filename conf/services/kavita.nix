{
  config,
  lib,
  ...
}:

let
  cfg = config.desert.services.kavita;
in
{
  options.desert.services.kavita = {
    enable = lib.mkEnableOption "Kavita reading server";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/kavita";
      description = "Directory where Kavita stores its state.";
    };

    httpAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address Kavita binds to.";
    };

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 5000;
      description = "Local Kavita HTTP port.";
    };

    tokenKeySecret = lib.mkOption {
      type = lib.types.str;
      default = "kavita_token_key";
      description = "SOPS secret containing Kavita's 512+ bit TokenKey.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.kavita = {
      enable = true;
      dataDir = cfg.dataDir;
      tokenKeyFile = config.sops.secrets.${cfg.tokenKeySecret}.path;

      settings = {
        IpAddresses = cfg.httpAddress;
        Port = cfg.httpPort;
      };
    };

    sops.secrets.${cfg.tokenKeySecret} = {
      owner = "kavita";
      group = "kavita";
      mode = "0400";
    };

    systemd.services.kavita.serviceConfig = {
      MemoryMax = "1G";
      CPUQuota = "150%";
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 6;
    };
  };
}
