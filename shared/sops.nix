{ inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../secrets/owais.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
}
