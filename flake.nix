{
  description = "Desert Thunder's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      self,
      ...
    }@inputs:
    let
      mkNixosHost = hostPath: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          hostPath
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              root = ./.;
              inherit (inputs) neovim-config;
              inherit inputs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.owais = import ./lib/nix/modules/home-manager/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        owais-nix-thinkpad = mkNixosHost ./lib/nix/hosts/thinkpad/configuration.nix;
        owais-nix-hp = mkNixosHost ./lib/nix/hosts/hp/configuration.nix;
        owais-nix-dell = mkNixosHost ./lib/nix/hosts/dell/configuration.nix;
      };
    };
}
