{ ... }:

{
  imports = [
    ./files.nix
  ];

  programs.plasma = {
    enable = true;

    workspace.lookAndFeel = "org.kde.breezedark.desktop";

    windows.allowWindowsToRememberPositions = true;

    # Timeout before lock screen automatically
    kscreenlocker.timeout = 30;

    input = {
      keyboard = {
        numlockOnStartup = "on";
        layouts = [{ layout = "us"; }];
      };
      touchpads = [{
        vendorId = "06cb";
        productId = "cec6";
        name = "SYNA801A:00 06CB:CEC6 Touchpad";
        enable = true;
        naturalScroll = true;
      }];
    }; # input

    shortcuts = {
      "services/kitty.desktop"."_launch" = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"."_launch" = "none";
    }; # shortcuts

    panels = [
      {
        location = "bottom";
        screen = 0;
        height = 44;
        floating = true;
        widgets = [
          # If you need configuration for your widget, instead of specifying the
          # the keys and values directly using the config attribute as shown
          # above, plasma-manager also provides some higher-level interfaces for
          # configuring the widgets. See modules/widgets for supported widgets
          # and options for these widgets. The widgets below shows two examples
          # of usage, one where we add a digital clock, setting 12h time and
          # first day of the week to Sunday and another adding a systray with
          # some modifications in which entries to show.
          {
            kickoff = {
              icon = "nix-snowflake";
            }; # kickoff
          } # widgets[0]
          "org.kde.plasma.pager" # widgets[1]
          {
            iconTasks = {
              launchers = [
                "applications:systemsettings.desktop"
                "applications:kitty.desktop"
                "preferred://filemanager"
                "preferred://browser"
                "applications:thunderbird.desktop"
                "applications:zotero.desktop"
              ];
              behavior.showTasks.onlyInCurrentScreen = true;
            }; # iconTasks
          } # widgets[2]
          # If no configuration is needed, specifying only the name of the
          # widget will add them with the default configuration.
          "org.kde.plasma.marginsseparator" # widgets[3]
          {
            systemTray = {
              items  = {
                extra = [
                  "org.kde.plasma.mediacontroller"
                  "org.kde.plasma.devicenotifier"
                  "org.kde.plasma.battery"
                  "org.kde.plasma.notifications"
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.manage-inputmethod"
                  "org.kde.plasma.keyboardlayout"
                  "org.kde.plasma.printmanager"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.bluetooth"
                  "org.kde.kscreen"
                  "org.kde.plasma.keyboardindicator"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.cameraindicator"
                  "org.kde.kdeconnect"
                ];
                hidden = [
                  "org.kde.plasma.clipboard"
                  "remmina-icon"
                ];
              }; # items
            }; # systemTray
          } # widgets[4]
          {
            name = "com.github.heqro.day-night-switcher";
            config.General = {
              iconA = "weather-clear-symbolic";
              iconB = "weather-clear-night-symbolic";
              colorA = "BreezeLight";
              colorB = "BreezeDark";
            }; # General
          } # widgets[5]
          {
            name = "com.kde.plasma.shutdownorswitch";
            config.General.showSuspend = true;
          } # widgets[6]
          {
            digitalClock = {
              time.showSeconds = "always";
              calendar = {
                showWeekNumbers = true;
                plugins = [ "alternatecalendar" "holidaysevents" ];
              };
            }; # digitalClock
          } # widgets[7]
          "org.kde.plasma.showdesktop" # widgets[8]
        ]; # widgets
      } # panels[0]
      {
        location = "bottom";
        screen = 1;
        height = 44;
        floating = true;
        widgets = [
          {
            iconTasks = {
              launchers = [];
              behavior.showTasks.onlyInCurrentScreen = true;
            }; # iconTasks
          }
        ];
      }
    ]; # panels
  }; # programs.plasma
}
