{ pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.supportedLocales = [ "all" ];
  services.xserver.xkb.layout = "cn";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5 = {
    addons = with pkgs; [ fcitx5-rime fcitx5-mozc fcitx5-gtk ];
    waylandFrontend = true;
  };
}