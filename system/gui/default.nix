{ pkgs, ... }:

{
  imports = [
    ./kde.nix
  ];

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
}
