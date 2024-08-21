{ ... }:

{
  imports = [
    ./files.nix
  ];

  programs.plasma = {
    enable = true;

    windows.allowWindowsToRememberPositions = true;

    # Timeout before lock screen automatically
    kscreenlocker.timeout = 30;

    input = {
      keyboard = {
        numlockOnStartup = "on";
        layouts = [{ layout = "us"; }];
      };
      touchpads = [{
        vendorId = "1739";
        productId = "52934";
        name = "SYNA801A:00 06CB:CEC6 Touchpad";
        enable = true;
        naturalScroll = true;
      }];
    }; # input

    shortcuts = {
      "services/kitty.desktop"."_launch" = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"."_launch" = "none";
    }; # shortcuts
  }; # programs.plasma
}
