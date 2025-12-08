{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = ../secrets/owais.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      keys_gh = {
        path = "${config.home.homeDirectory}/.local/share/sops/keys_gh";
      };

      keys_codeberg = {
        path = "${config.home.homeDirectory}/.local/share/sops/keys_codeberg";
      };

      keys_tangled = {
        path = "${config.home.homeDirectory}/.local/share/sops/keys_tangled";
      };
    };
  };

  # Ensure directories exist
  home.file.".local/share/sops/.keep".text = "";
  home.file.".config/sops/age/.keep".text = "";
}
