{
  description = "Shinri's ThinkPad P16v configuration with lanzaboote and disko";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

  };

  outputs = { self, nixpkgs, ...} @ inputs: {
    # # Standalone Home Manager Setup:
    # homeConfigurations.shinri =
    #   inputs.home-manager.lib.homeManagerConfiguration {
    #     # Ensure Plasma Manager is available:
    #     extraModules = [
    #       inputs.plasma-manager.homeManagerModules.plasma-manager
    #     ];

    #     # Specify the path to my home manager configuration
    #     configuration = import ./home.nix;

    #     homeDirectory = "/home/shinri";
    #   };

    # # A shell where Home Manager can be used:
    # devShells."x86_64-linux".default =
    #   nixpkgs.mkShell {
    #     buildInputs = [
    #       inputs.home-manager.packages."x86_64-linux".home-manager
    #     ];
    #   };
      
    nixosConfigurations = {
      "thinkpad-p16v" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # This is not a complete NixOS configuration and you need to reference
          # your normal configuration here.

          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }

          ({ pkgs, lib, ... }: {

            environment.systemPackages = [
              # For debugging and troubleshooting Secure Boot.
              pkgs.sbctl
            ];

            # Lanzaboote currently replaces the systemd-boot module.
            # This setting is usually set to true in configuration.nix
            # generated at installation time. So we force it to false
            # for now.
            boot.loader.systemd-boot.enable = lib.mkForce false;

            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/etc/secureboot";
            };
          })

          {
            imports = [
              ./configuration.nix
            ];
          }
        ];
      };
    };
  };
}
