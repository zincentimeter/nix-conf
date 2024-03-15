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

    fubuki-pkgs = {
      url = "git+https://git.sr.ht/~fubuki/stratosphere";
    };
  };

  outputs = { self, nixpkgs, ...} @ inputs: 
  let
    system = "x86_64-linux";

    # Patching nixpkgs
    # See https://github.com/NixOS/nix/issues/3920
    patches = [
      {
        name = "plasma-6.patch";
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/286522.patch";
        hash = "sha256-/qmPT28SD8m6sQbCutQIk57KGLQKAhjERU4ssdoIFX8=";
      }
    ];
    originNixpkgs = inputs.nixpkgs;
    patchedNixpkgs =
      let
        originPkgs = originNixpkgs.legacyPackages.${system};
      in
        originPkgs.applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
          patches = map originPkgs.fetchpatch patches;
        };

    originLib = originNixpkgs.lib;
    # Copied from <nixpkgs>/flake.nix
    patchedLib = originLib.lists.foldl (a: b: a.extend b)
      (import (patchedNixpkgs + "/lib"))
      [
        (import (patchedNixpkgs + "/lib/flake-version-info.nix") self)
        (final: prev: {
          nixos = import (patchedNixpkgs + "/nixos/lib") { lib = final; };
          nixosSystem = args:
            import (patchedNixpkgs + "/nixos/lib/eval-config.nix") (
              {
                lib = final;
                # Allow system to be set modularly in nixpkgs.system.
                # We set it to null, to remove the "legacy" entrypoint's
                # non-hermetic default.
                system = null;
              } // args
            );
        })
      ];

    nixpkgs = patchedNixpkgs;
    lib = patchedLib;
  in
  {
    # Standalone Home Manager Setup:
    # homeConfigurations.shinri =
    #   inputs.home-manager.lib.homeManagerConfiguration {

    #     # Ensure Plasma Manager is available:
    #     extraModules = [
    #       inputs.plasma-manager.homeManagerModules.plasma-manager
    #     ];

    #     homeDirectory = "/home/shinri";
    #     # Specify the path to my home manager configuration
    #     configuration = import ./home.nix;

    #   };

    # A shell where Home Manager can be used:
    # invoke dev shell by `nix develop` under that flake dir
    # devShells."x86_64-linux".default =
    #   nixpkgs.legacyPackages."x86_64-linux".mkShell {
    #     buildInputs = [
    #       inputs.home-manager.packages."x86_64-linux".home-manager
    #     ];
    #   };
      
    nixosConfigurations = {
      "thinkpad-p16v" = lib.nixosSystem {
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

              users.shinri.imports = [
                inputs.plasma-manager.homeManagerModules.plasma-manager
                ./home.nix
              ];
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

  # nixConfig = {
  #   extra-substituters = [
  #     "https://mirror.sjtu.edu.cn/nix-channels"
  #     "https://nix-community.cachix.org"
  #     "https://usc1.contabostorage.com/43f37228fc484988a5809f4bc0e3ca6e:nix-cache"
  #   ];
  #   extra-trusted-public-keys = [
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     "kyaru-nix-cache-1:Zu6gS5WZt4Kyvi95kCmlKlSyk+fbIwvuuEjBmC929KM="
  #   ];
  # };
}
