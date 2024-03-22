{
  description = "Shinri's ThinkPad P16v configuration with lanzaboote and disko";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
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

  };

  outputs = { self, nixpkgs, ...} @ inputs: 
  {
    nixosConfigurations = {
      "thinkpad-p16v" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
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
