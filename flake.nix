{
  description = "Shinri's ThinkPad P16v configuration with lanzaboote and disko";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # dependency of lanzaboote
    crane = {
      url = "github:ipetkov/crane/v0.16.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
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
    zincentimeter = {
      url = "github:zincentimeter/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Gyara's user custom software repository
    stratosphere = {
      url = "git+https://git.sr.ht/~fubuki/stratosphere";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for naiveproxy
    sn0wm1x = {
      url = "github:sn0wm1x/ur";
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
        # This is not a complete NixOS configuration and you need to reference
        # your normal configuration here.
        ./configuration.nix
        # Flake modules that enhances nixos configuration
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        inputs.impermanence.nixosModules.impermanence
        inputs.nix-index-db.nixosModules.nix-index
      ];
    }; # nixosConfigurations

    nixosConfigurations."tm1701" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        # This is not a complete NixOS configuration and you need to reference
        # your normal configuration here.
        ./remote/tm1701.nix
        # Flake modules that enhances nixos configuration
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
