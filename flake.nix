{
  description = "PLounge Matrix Chat";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixos-generator = {
      url = "github:nix-community/nixos-generators/d002ce9b6e7eb467cd1c6bb9aef9c35d191b5453";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    let
      modules = [
        {
          # Pin nixpkgs to the flake input.
          nix.registry.nixpkgs.flake = nixpkgs;
        }
        ./configuration.nix
      ];
      formatting = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          formatter = pkgs.nixfmt-tree;
        }
      );
      targetSystem = "x86_64-linux";
    in
    {
      packages.${targetSystem} = {
        digitalOceanVM = inputs.nixos-generator.nixosGenerate {
          system = targetSystem;
          format = "do"; # DigitalOcean
          inherit modules;
        };
      };
      nixosConfigurations.monotone = nixpkgs.lib.nixosSystem {
        system = targetSystem;
        inherit modules;
      };
      deploy.nodes = {
        monotone = {
          # Don't forget to set your hostname appropriately!
          hostname = "165.227.76.75";
          sshUser = "lixy";
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.monotone;
          };
        };
      };

      checks = builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks self.deploy
      ) inputs.deploy-rs.lib;
    }
    // formatting;
}
