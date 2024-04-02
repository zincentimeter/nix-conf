{ ... }:

{
  networking.hostName = "thinkpad-p16v"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Proxy
  services.v2raya.enable = true;
}