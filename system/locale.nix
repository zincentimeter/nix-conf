{ pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = false;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.supportedLocales = [ "all" ];

  # Configure keymap in X11
  services.xserver.xkb.layout = "cn";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-rime
        fcitx5-chinese-addons
      ];
      waylandFrontend = true;
    };
  };
}
