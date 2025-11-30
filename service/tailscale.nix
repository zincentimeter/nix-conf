{ ... }:

{
  # after that, run: 
  # > tailscale up --accept-dns=false --hostname=thinkpad-p16v-nixos --login-server=https://wired.side7.click:443
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
  };
}
