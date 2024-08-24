{ pkgs, lib, ... }:

{
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.hostName = "thinkpad-p16v"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Proxy
  services.v2raya.enable = true;

  environment.systemPackages = [ pkgs.dae ];
  # To debug:
  # systemd.services.v2raya.serviceConfig.ExecStart = lib.mkForce ''
  #   ${lib.getExe pkgs.v2raya} --log-disable-timestamp --log-level=debug
  # '';
}
