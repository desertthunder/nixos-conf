{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    neovim-config = {
      url = "github:desertthunder/nvim";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-darwin,
      home-manager,
      nix-darwin,
      sops-nix,
      self,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        owais-nix-thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./machines/thinkpad/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                root = ./.;
                inherit (inputs) neovim-config;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.owais = import ./shared/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };

        owais-nix-hp = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./machines/hp/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                root = ./.;
                inherit (inputs) neovim-config;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.owais = import ./shared/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };

        owais-nix-nuc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./machines/nuc/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                root = ./.;
                inherit (inputs) neovim-config;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.owais = import ./shared/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };

      darwinConfigurations = {
        owais-nix-air = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            {
              nixpkgs.pkgs = import nixpkgs-darwin {
                system = "aarch64-darwin";
                config.allowUnfree = true;
              };
            }

            ./machines/mac/air/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                root = ./.;
                inherit (inputs) neovim-config;
                inherit inputs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.owais =
                { lib, ... }:
                {
                  imports = [ ./shared/home.nix ./shared/sops-hm.nix ];
                  home.homeDirectory = lib.mkForce "/Users/owais";
                  xresources = { };
                };
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };
    };
}
