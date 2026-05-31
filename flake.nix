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
              home-manager.users.owais = (import ./conf/shared.nix).home;
              # Do not move/overwrite existing home files during rebuilds; fail on conflicts instead.
              home-manager.backupFileExtension = null;
            }
          ];
        };

        owais-nix-hp = nixpkgs.lib.nixosSystem {
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
              home-manager.users.owais = (import ./conf/shared.nix).home;
              # Do not move/overwrite existing home files during rebuilds; fail on conflicts instead.
              home-manager.backupFileExtension = null;
            }
          ];
        };

      };
    };
}
