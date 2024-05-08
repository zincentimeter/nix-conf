{
  description = "Shinri's ThinkPad P16v configuration with lanzaboote and disko";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    crane = {
      url = "github:ipetkov/crane/v0.16.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.crane.follows = "crane";
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

  outputs = { self, nixpkgs, nixpkgs-stable, ... } @ inputs:
  {
    nixosConfigurations = {
      # Use `rec` to use `system` variable inside overlays
      "thinkpad-p16v" = nixpkgs.lib.nixosSystem rec {

        system = "x86_64-linux";
	specialArgs = {
	  inherit inputs;
	};
        modules = [
          {
            # Patching nixpkgs with customized packages
            # e.g. apps from other sources or stable branch
            nixpkgs.overlays = [
              # Overlay function below
              # (final: prev: {
              #     noto-fonts-cjk = nixpkgs.legacyPackages.${system}.noto-fonts-cjk.overrideAttrs
              #       (finalAttrs: previousAttrs:
              #         {
              #           src = previousAttrs.src.override {
              #             hash = "sha256-GXULnRPsIJRdiL3LdFtHbqTqSvegY2zodBxFm4P55to=";
              #             sparseCheckout = [ "Sans/OTC" ];
              #           };
              #           installPhase = ''
              #             install -m444 -Dt $out/share/fonts/opentype/noto-cjk Sans/OTC/*.ttc
              #           '';
              #         }
              #       );
              #   # <package_name> = nixpkgs-stable.legacyPackages.${system}.<package_name>;
              # })
            ];
          }
          # This is not a complete NixOS configuration and you need to reference
          # your normal configuration here.
          {
            imports = [
              ./configuration.nix
            ];
          }

          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops

        ];
      };
    };
  };

}
