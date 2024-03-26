{ config, lib, pkgs, ... }:

{
  # Configure GUI here
  # programs.hyprland.enable = true;
  # hint electron apps to use wayland
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # programs.waybar.enable = true;

  # Enable the Plasma 6 Desktop Environment.
  # services.xserver.desktopManager.plasma5.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Use x11 as default since I meet a wierd numlock problem
  # Resembling https://github.com/wez/wezterm/issues/1869#user-content-its-a-mutter-problem
  services.xserver.displayManager.defaultSession = "plasmax11";
  services.xserver.displayManager.sddm = {
    wayland.enable = false;
    enable = true;
    autoNumlock = true;
  };

  # Enable the X11 windowing system. (For unstable Plasma 6, xserver is for sddm)
  services.xserver.enable = true;

}
