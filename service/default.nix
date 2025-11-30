{ ... }:

{
  imports = [
    ./tailscale.nix
    ./ollama.nix
    ./onedrive.nix
    ./yggdrasil.nix
  ];

  virtualisation.waydroid.enable = true;

}
