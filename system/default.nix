{ ... }:

{
  imports = [
    # Boot options and Lanzaboote for SecureBoot
    ./boot.nix

    # Disko
    # "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
    ./disko.nix

    # Graphic Interface Configuration
    ./gui

    # Language-related
    ./locale.nix

    # Fonts
    ./font.nix
  ];
}