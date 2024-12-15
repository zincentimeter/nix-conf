{
  description = "Shinri's ThinkPad P16v configuration with lanzaboote and disko";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # dependency of lanzaboote
    flake-utils.url = "github:numtide/flake-utils";

    # dependency of lanzaboote
    crane = {
      url = "github:ipetkov/crane/v0.16.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    # secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.crane.follows = "crane"; 
      inputs.pre-commit-hooks-nix.follows = "";
    };

    # declarative disk partition
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # managing the /home folder
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # managing KDE plasma GUI profile declaratively
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Lets you choose what files and directories you want to keep
    # between reboots - the rest are thrown away.
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Shinri's SSH public keys uploaded to sourcehut.
    sourcehut-keys = {
      url = "https://meta.sr.ht/~zincentimeter.keys";
      flake = false;
    };

    # Nix User Repository (NUR)
    # Gyara's user custom software repository
    stratosphere = {
      url = "git+https://git.sr.ht/~fubuki/stratosphere";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apple Fonts Flake, including San Francisco etc.
    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = { ... } @ inputs:
  {
    nixosConfigurations."thinkpad-p16v" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        {
          # Patching nixpkgs with customized packages
          # e.g. apps from other sources or stable branch
          nixpkgs.overlays =
          [
            inputs.stratosphere.overlays.default
            # Overlay function below
            (final: prev: 
            let
              pkgsMaster = import inputs.nixpkgs-master {
                system = "x86_64-linux";
                config.permittedInsecurePackages = [
                  "cinny-4.2.2"
                  "cinny-unwrapped-4.2.2"
                ];
              };
            in
            {
              # Use latest Oama, overriding nixpkgs' pkg
              # oama = prev.oama.overrideAttrs {
              #   version = "0.16";
              #   src = prev.fetchFromGitHub {
              #     owner = "pdobsan";
              #     repo = "oama";
              #     rev = "b4fbc1efa5787d5bd13e6cc3eeca19303fca891f";
              #     hash = "sha256-5/0giScOUIU3VKgftzyq7mEXD+yz54Di4fdEo0jgoB8=";
              #   };
              # };
              # Use latest problem-free Cinny
              cinny-desktop = pkgsMaster.cinny-desktop;
              inherit (inputs.apple-fonts.packages."x86_64-linux")
                sf-pro sf-compact sf-mono sf-arabic ny
              ;
            })
            /* (final: prev: { 
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
              
            })
            */
          ];
        }
        # This is not a complete NixOS configuration and you need to reference
        # your normal configuration here.
        ./configuration.nix

        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        inputs.impermanence.nixosModules.impermanence
        inputs.nix-index-db.nixosModules.nix-index

      ];
    }; # nixosConfigurations
  };
}
