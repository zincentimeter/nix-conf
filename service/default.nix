{ ... }:

{
  imports = [
    ./tailscale.nix
    ./ollama.nix
    ./onedrive.nix
  ];

  virtualisation.waydroid.enable = true;

}
