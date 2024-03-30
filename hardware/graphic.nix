{ config, pkgs, ... }:

{
  # Graphic settings
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.vaapiVdpau ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  environment.systemPackages = [ pkgs.nvidia-vaapi-driver ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    powerManagement = {
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    	enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
	    finegrained = false;
    };

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Hybrid Graphics (Nvidia Optimus PRIME)
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Optimus Option C: Reverse Sync Mode (Experimental)
      reverseSync.enable = true;
      # Enable if using an external GPU
      allowExternalGpu = false;

      # Gathered from `lscpi -c display`
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}