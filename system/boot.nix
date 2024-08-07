{ pkgs, lib, ... }:

{
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.kernel.sysctl = {
    # https://gist.github.com/manuelmazzuola/4ffa90f5f5d0ddacda96
    "kernel.sysrq" = 1;
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

  boot.crashDump = {
    enable = true;
    kernelParams = [ "single" "boot.shell_on_fail" ];
    reservedMemory = "256M";
  };

}
