{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-config = {
      url = "github:desertthunder/nvim";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      self,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        owais-nix-thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
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
    };
}
