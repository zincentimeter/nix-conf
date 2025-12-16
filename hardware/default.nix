{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./security.nix
    ./graphic.nix
  ];

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
  };
  # autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Sound configuration
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable trackpoint
  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  # fwupd, for firmware updates
  services.fwupd.enable = true;

  # thunderbolt userspace daemon
  services.hardware.bolt.enable = true;

}
