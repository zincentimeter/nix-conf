{ pkgs, ... }:

{
  # hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.waybar.enable = true;

  # SDDM requires services.xserver.enable to be true
  services.xserver.enable = true;
  services.xserver.displayManager.sddm = {
    wayland.enable = false;
    enable = true;
    autoNumlock = true;
  };

  environment.systemPackages = [
    pkgs.kitty
    # A notification daemon
    pkgs.dunst
    # App launchers
    pkgs.bemenu

    pkgs.xdg-desktop-portal-hyprland
  ];

  # Must-have
  # https://wiki.hyprland.org/Useful-Utilities/Must-have/
  # XDG Desktop Portal
  xdg.portal.wlr.enable = true;
  # Authentication Agent
  security.polkit.enable = true;
}
