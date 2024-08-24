{ pkgs, ... }:

{
  # Configure GUI here
  # programs.hyprland.enable = true;
  # hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # programs.waybar.enable = true;

  # Enable the Plasma 6 Desktop Environment.
  # services.xserver.desktopManager.plasma5.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
    autoNumlock = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-thunderbolt
    vulkan-tools
  ];

  programs.kdeconnect.enable = true;
}
