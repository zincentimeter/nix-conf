{ ... }:

{
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    settings = {
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
