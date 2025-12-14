{ config, pkgs, ... }:

{
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time.
  boot.loader.systemd-boot.enable = false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.kernel.sysctl = {
    # https://gist.github.com/manuelmazzuola/4ffa90f5f5d0ddacda96
    "kernel.sysrq" = 1;
    # Disable NMI watchdog to save power
    "kernel.nmi_watchdog" = 0;
  };

  boot.kernelParams = [
    #   "systemd.journald.forward_to_console=1"
    #   "console=tty1"
    #   # Halt all CPUs after the first oops has been printed for
    #   # the specified number of seconds.  This is to be used if
    #   # your oopses keep scrolling off the screen.
    #   "pause_on_oops=20"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  # Add loopback device to enable virtual camera
  # https://nixos.wiki/wiki/OBS_Studio
  # Inspired by https://www.bilibili.com/read/cv27040222/
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
