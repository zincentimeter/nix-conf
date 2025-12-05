{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    # See: https://sw.kovidgoyal.net/kitty/conf.html
    settings = {
      cursor_blink_interval = 0;
    };
    shellIntegration.enableFishIntegration = true;
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "dark:Builtin Tango Dark,light:Builtin Tango Light";
    };
  };

  xdg.configFile = {
    "kitty/dark-theme.auto.conf".source = "${pkgs.kitty-themes}/share/kitty-themes/themes/default.conf";
    "kitty/light-theme.auto.conf".source = "${pkgs.kitty-themes}/share/kitty-themes/themes/OneHalfLight.conf";
  };
}
