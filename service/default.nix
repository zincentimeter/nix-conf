{ ... }:

{
  imports = [
    ./tailscale.nix
    ./onedrive.nix
    ./yggdrasil.nix
  ];

  virtualisation.waydroid.enable = true;

}
