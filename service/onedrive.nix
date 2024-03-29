{ pkgs, ... }:

{
  # services.onedrive.enable = true;

  environment.systemPackages = [
    # onedrive-fuse
    pkgs.onedrive-fuse
  ];
}