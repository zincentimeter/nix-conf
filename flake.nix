{
  description = "A flake for toast-185 server on Ubuntu";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "chenmeng" ];
    accept-flake-config = true;
  };

  # Flake outputs
  outputs = { self, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { inherit system; };
  in
  {
    homeConfigurations = {
      "chenmeng" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      # The Nix packages provided in the environment
      packages = with pkgs; [
        gnumake
        gcc # The GNU Compiler Collection
      ];

      shellHook = ''
        fish
      '';
    };
  };
}
