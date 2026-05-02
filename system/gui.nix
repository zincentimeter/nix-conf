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
  services.displayManager.plasma-login-manager.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-thunderbolt
    vulkan-tools
  ];

  programs.kdeconnect.enable = true;

  # OBS studio
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override { cudaSupport = true; };
    plugins = with pkgs.obs-studio-plugins; [
      # screen capture on wlroots based wayland compositors
      wlrobs
      # show keyboard on stream
      input-overlay
      # select audio by application
      obs-pipewire-audio-capture
    ]; # plugins
    enableVirtualCamera = true;
  }; # programs.obs-studio
}
