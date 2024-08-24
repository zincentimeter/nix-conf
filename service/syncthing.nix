{ ... }:

{
  services.syncthing = {
    enable = true;
    relay.enable = true;
    systemService = true;

    user = "shinri";
    group = "users";
    dataDir = "/home/shinri";
    configDir = "/home/shinri/.config/syncthing";

    settings = {
      gui = {
        address = "127.0.0.1:8384";
      };
      # Don't add devices through webUI
      overrideDevices = true;
      devices = {
      };
      folders = {
      };
    };
  };
}