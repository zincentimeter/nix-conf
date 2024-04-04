{ pkgs, lib, ... }:

{
  networking.hostName = "thinkpad-p16v"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Proxy
  services.v2raya.enable = true;
  # To debug:
  # systemd.services.v2raya.serviceConfig.ExecStart = lib.mkForce ''
  #   ${lib.getExe pkgs.v2raya} --log-disable-timestamp --log-level=debug
  # '';
}