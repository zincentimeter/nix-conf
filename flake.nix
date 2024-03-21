{
  description = "A flake for toast-185 server on Ubuntu";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "chenmeng" ];
    accept-flake-config = true;
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      # The Nix packages provided in the environment
      packages = with pkgs; [
        boost # The Boost libraries
        gcc # The GNU Compiler Collection
      ];
    };
  };
}
