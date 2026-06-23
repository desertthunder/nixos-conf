/**

  NOTE: The line `home-manager.backupFileExtension = null;` should be added at the
        end of each machine's configuration because we do not want to move/overwrite
        existing home files during rebuilds. We want to fail on conflicts instead.
*/
{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-config = {
      url = "github:desertthunder/nvim";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tangled = {
      url = "git+https://tangled.org/@tangled.org/core";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      self,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nix-haxorus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./conf/machines/thinkpad/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                root = ./.;
                inherit (inputs) neovim-config;
                inherit inputs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.owais = {
                imports = [
                  (import ./conf/shared.nix).home
                  ./conf/modules/de/gnome-home.nix
                  ./conf/modules/de/hypr-home.nix
                ];
              };
              home-manager.backupFileExtension = null;
            }
          ];
        };

        nix-baxcalibur = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./conf/machines/hp/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                root = ./.;
                inherit (inputs) neovim-config;
                inherit inputs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.owais = {
                imports = [
                  (import ./conf/shared.nix).home
                  ./conf/modules/de/gnome-home.nix
                ];
              };
              home-manager.backupFileExtension = null;
            }
          ];
        };

      };
    };
}
