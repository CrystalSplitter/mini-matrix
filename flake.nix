{
  description = "PLounge Matrix Chat";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    colmena.url = "github:zhaofengli/colmena";
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
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          digitalOceanVM = inputs.nixos-generator.nixosGenerate {
            inherit system;
            format = "do"; # DigitalOcean
            modules = [
              {
                # Pin nixpkgs to the flake input.
                nix.registry.nixpkgs.flake = nixpkgs;
              }
              ./configuration.nix
            ];
          };
        };
        formatter = pkgs.nixfmt-tree;
      }
    )
    // {
      colmenaHive = inputs.colmena.lib.makeHive {
        meta = {
          # All instances are x86_64-linux.
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ ];
          };
        };

        monotone =
          {
            name,
            nodes,
            pkgs,
            ...
          }:
          {
            boot.isContainer = true;
            deployment = {
              targetHost = "165.227.76.75";
              targetUser = "lixy";
            };
            time.timeZone = "UTC";
            fileSystems."/" = {
              device = "/dev/vda1";
              fsType = "ext4";
            };
          };
      };
    };
}
