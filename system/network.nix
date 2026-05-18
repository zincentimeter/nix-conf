{ pkgs, ... }:

{
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.hostName = "thinkpad-p16v"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Secure Shell Client behavior
  programs.ssh = {
    forwardX11 = null;
    setXAuthLocation = true;
  };
  programs.nexttrace.enable = true;
}
