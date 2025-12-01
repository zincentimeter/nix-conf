{ config, ... }:

{
  sops.secrets.yggdrasil-key = {
    format = "binary";
    sopsFile = ./yggdrasil.key;
  };

  services.yggdrasil = {
    enable = true;
    configFile = config.sops.secrets.yggdrasil-key.path;
    settings = {
      IfName = "ygg0";
      Peers = [
        # public peers from nebula
        "tls://45.62.118.101:5563"
        "tls://45.62.118.101:5564"
        # public peers from https://publicpeers.neilalexander.dev/
        "tls://yg-hkg.magicum.net:32333" # Hong Kong
        "tls://astrra.space:55535" # Japan
      ]; # Peers
    }; # settings
  }; # services.yggdrasil
}
