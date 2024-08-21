{ ... }:

{
  programs.plasma.configFile = {
    kwinrc = {
      XWayland.Scale = 2;
      Wayland.InputMethod = {
        value = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
        shellExpand = true;
      };
    };

    # https://github.com/totte/configurations/blob/master/.kde4/share/config/kdeglobals.example
    kdeglobals = {
      General = {
        TerminalApplication = "kitty";
        TerminalService = "kitty.desktop";
      };
      KDE = {
        # This is actually for Dolphin
        # Don't know why it's here
        SingleClick = false;
        ShowDeleteCommand = false;
      };
    };

    # Not first use
    kwalletrc.Wallet."First Use" = false;

    plasma-localerc =
    let
      us = "en_US.UTF-8";
      tw = "zh_TW.UTF-8";
      cn = "zh_CN.UTF-8";
    in
    {
      Formats = {
        LANG = us;
        LC_ADDRESS = tw;
        LC_MEASUREMENT = tw;
        LC_MONETARY = cn;
        LC_NAME= tw;
        LC_NUMERIC = tw;
        LC_PAPER = tw;
        LC_TELEPHONE = cn;
        LC_TIME = cn;
      }; # Formats
      Translations.LANGUAGE = us;
    }; # plasma-localerc

    spectaclerc = {
      General = {
        clipboardGroup = "PostScreenshotCopyImage";
        launchAction = "UseLastUsedCapturemode";
        useReleaseToCapture = true;
      };
    };
    
    # Used for Ark to fallback codepages
    klanguageoverridesrc.Language = {
      ark = "@ByteArray(en_US:ja)";
    };

    # Widget showing chinese lunar year
    plasma_calendar_alternatecalendar.General.calendarSystem = "Chinese";
    plasma_calendar_holiday_regions.General.selectedRegions = "cn_zh-cn";
  };

  # https://github.com/pjones/plasma-manager/tree/trunk?tab=readme-ov-file#make-your-configuration-more-declarative-with-overrideconfig
  programs.plasma.overrideConfig = true;
  # https://github.com/nix-community/plasma-manager/blob/trunk/modules/files.nix
  programs.plasma.resetFiles = [
    "auroraerc"
    "baloofilerc"
    "dolphinrc"
    "ffmpegthumbsrc"
    "kactivitymanagerdrc"
    "katerc"
    "kcminputrc"
    "kded5rc"
    "kded6rc"
    "kdeglobals"
    "kgammarc"
    "kglobalshortcutsrc"
    "khotkeysrc"
    "kiorc"
    "klaunchrc"
    "klipperrc"
    "kmixrc"
    "krunnerrc"
    "kscreenlockerrc"
    "kservicemenurc"
    "ksmserverrc"
    "ksplashrc"
    "kwalletrc"
    "kwin_rules_dialogrc"
    "kwinrc"
    "kwinrulesrc"
    "kxkbrc"
    "plasma_calendar_alternatecalendar"
    "plasma_calendar_astronomicalevents"
    "plasma_calendar_holiday_regions"
    "plasma-localerc"
    "plasmanotifyrc"
    "plasmarc"
    "plasmashellrc"
    "powerdevilrc"
    "systemsettingsrc"
    "spectaclerc"
    "klanguageoverridesrc"
    "plasma_calendar_alternatecalendar"
    "plasma_calendar_holiday_regions"
  ];

}
