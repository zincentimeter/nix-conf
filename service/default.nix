{ ... }:

{
  imports = [
    ./tailscale.nix
    ./onedrive.nix
  ];

  virtualisation.waydroid.enable = true;

}
