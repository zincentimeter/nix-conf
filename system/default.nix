{ ... }:

{
  imports = [
    # Boot options and Lanzaboote for SecureBoot
    ./boot.nix

    # Disko
    # "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
    ./disko.nix

    # Graphic Interface Configuration
    ./gui.nix

    # Language-related
    ./locale.nix

    # Fonts
    ./font.nix

    # Internet, DNS, etc.
    ./network.nix

    # Persistent things
    ./persist

    # Nix, Nixpkgs related
    ./nix.nix

    # Users related configuration, and basic environment (Shells) for all users including root
    ./users.nix
  ];
}
