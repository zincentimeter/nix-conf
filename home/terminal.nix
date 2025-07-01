{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    # See: https://sw.kovidgoyal.net/kitty/conf.html
    settings = {
      cursor_blink_interval = 0;
      background_opacity = 0.5;
      background_blur = 30;
      dynamic_background_opacity = true;
    };
    shellIntegration.enableFishIntegration = true;
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile = {
    "kitty/dark-theme.auto.conf".source = "${pkgs.kitty-themes}/share/kitty-themes/themes/default.conf";
    "kitty/light-theme.auto.conf".source = "${pkgs.kitty-themes}/share/kitty-themes/themes/OneHalfLight.conf";
  };
}
