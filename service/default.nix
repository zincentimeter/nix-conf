{ ... }:

{
  imports = [
    ./tailscale.nix
    ./syncthing.nix
    ./ollama.nix
    ./onedrive.nix
  ];

  virtualisation.waydroid.enable = true;

}
