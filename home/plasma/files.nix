{ ... }:

{
  programs.plasma.configFile = {

    # Don't show plasma broswer integration again
    kded6rc.PlasmaBrowserIntegration.shownCount = 100;

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

    # highlight everthing changed
    systemsettingsrc.systemsettings_sidebar_mode.HighlightNonDefaultSettings = true;

    spectaclerc = {
      General = {
        clipboardGroup = "PostScreenshotCopyImage";
        launchAction = "UseLastUsedCapturemode";
        useReleaseToCapture = true;
      };
      GuiConfig.captureMode = 0;
    };
    
    # Used for Ark to fallback codepages
    klanguageoverridesrc.Language = {
      ark = "@ByteArray(en_US:ja)";
    };

    # Widget showing chinese lunar year
    plasma_calendar_alternatecalendar.General.calendarSystem = "Chinese";
    plasma_calendar_holiday_regions.General.selectedRegions = "cn_zh-cn";

    dolphinrc = {
      DetailsMode = {
        IconSize = 22;
        PreviewSize = 22;
      };
      General = {
        AutoExpandFolders = true;
      };
      InformationPanel.dateFormat = "ShortFormat";
    };

    okularrc = {
      MainWindow.MenuBar = "Disabled";
      "MainWindow/Toolbar mainToolBar".ToolButtonStyle = "IconOnly";
    };
  }; # configFile

  programs.plasma.dataFile = {
    "dolphin/view_properties/global/.directory" = {
      Dolphin = {
        SortHiddenLast = true;
        SortOrder = 1;
        SortRole = "modificationtime";
        # https://www.reddit.com/r/kde/comments/68zb89/how_to_make_the_details_view_mode_the_default/
        # https://github.com/usama8800/dotfiles/blob/408067dff947ab7621016af9b01ed9edd03fedf9/.dotfiles/nixos/modules/home-manager.nix#L236
        ViewMode = 1;
      };
      Settings.HiddenFilesShown = true;
    };
  }; # dataFile

  # https://github.com/pjones/plasma-manager/tree/trunk?tab=readme-ov-file
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
    "okularrc"
  ];

}
