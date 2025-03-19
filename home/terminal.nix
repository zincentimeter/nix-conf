{ ... }:

{
  programs.kitty = {
    enable = true;
    # See: https://sw.kovidgoyal.net/kitty/conf.html
    settings = {
      cursor_blink_interval = 0;
    };
    shellIntegration.enableFishIntegration = true;
  };
}
