{
  programs.plasma = {
    enable = true;

    # https://github.com/pjones/plasma-manager/tree/trunk?tab=readme-ov-file#make-your-configuration-more-declarative-with-overrideconfig
    # overrideConfig = true;

    shortcuts = {
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";

      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";

      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = ["Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku"];

      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute"];
      "kmix"."mute" = "Volume Mute";

      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";

      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = ["Ctrl+F10" "Launch (C)"];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."Overview" = "Meta+W";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."ShowDesktopGrid" = "Meta+F8";
      "kwin"."Suspend Compositing" = "Alt+Shift+F12";
      "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
      "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Switch to Desktop 1" = "Ctrl+F1";
      "kwin"."Switch to Desktop 2" = "Ctrl+F2";
      "kwin"."Switch to Desktop 3" = "Ctrl+F3";
      "kwin"."Switch to Desktop 4" = "Ctrl+F4";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+="];
      "kwin"."view_zoom_out" = "Meta+-";

      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";

      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."powerProfile" = ["Battery" "Meta+B"];

      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+A";
      "plasmashell"."previous activity" = "Meta+Shift+A";
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";

      "services/kitty.desktop"."_launch" = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"."_launch" = "none";
    };

    configFile = {
      "baloofilerc"."General"."exclude filters version" = 9;

      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      "kded5rc"."Module-device_automounter"."autoload" = false;

      "kcminputrc"."Keyboard"."NumLock" = 0;

      "kdeglobals"."General"."AllowKDEAppsToRememberWindowPositions" = true;
      "kdeglobals"."General"."TerminalApplication" = "kitty";
      "kdeglobals"."General"."TerminalService" = "kitty.desktop";
      "kdeglobals"."KDE"."SingleClick" = false;
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 140;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";

      "kglobalshortcutsrc"."ActivityManager"."_k_friendly_name" = "Activity Manager";
      "kglobalshortcutsrc"."KDE Keyboard Layout Switcher"."_k_friendly_name" = "Keyboard Layout Switcher";
      "kglobalshortcutsrc"."kaccess"."_k_friendly_name" = "Accessibility";
      "kglobalshortcutsrc"."kcm_touchpad"."_k_friendly_name" = "Touchpad";
      "kglobalshortcutsrc"."khotkeys"."_k_friendly_name" = "Custom Shortcuts Service";
      "kglobalshortcutsrc"."kmix"."_k_friendly_name" = "Audio Volume";
      "kglobalshortcutsrc"."ksmserver"."_k_friendly_name" = "Session Management";
      "kglobalshortcutsrc"."kwin"."_k_friendly_name" = "KWin";
      "kglobalshortcutsrc"."mediacontrol"."_k_friendly_name" = "Media Controller";
      "kglobalshortcutsrc"."org_kde_powerdevil"."_k_friendly_name" = "KDE Power Management System";
      "kglobalshortcutsrc"."plasmashell"."_k_friendly_name" = "plasmashell";

      "kiorc"."Confirmations"."ConfirmDelete" = true;
      "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
      "kwalletrc"."Wallet"."First Use" = false;

      "kxkbrc"."Layout"."DisplayNames" = "";
      "kxkbrc"."Layout"."LayoutList" = "cn";
      "kxkbrc"."Layout"."Use" = true;
      "kxkbrc"."Layout"."VariantList" = "";

      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
      "plasma-localerc"."Formats"."LC_ADDRESS" = "zh_TW.UTF-8";
      "plasma-localerc"."Formats"."LC_MEASUREMENT" = "zh_TW.UTF-8";
      "plasma-localerc"."Formats"."LC_MONETARY" = "zh_CN.UTF-8";
      "plasma-localerc"."Formats"."LC_NAME" = "zh_TW.UTF-8";
      "plasma-localerc"."Formats"."LC_NUMERIC" = "zh_TW.UTF-8";
      "plasma-localerc"."Formats"."LC_PAPER" = "zh_TW.UTF-8";
      "plasma-localerc"."Formats"."LC_TELEPHONE" = "zh_CN.UTF-8";
      "plasma-localerc"."Formats"."LC_TIME" = "zh_CN.UTF-8";
      "plasma-localerc"."Translations"."LANGUAGE" = "en_US";

      "plasmarc"."Wallpapers"."usersWallpapers" = "";

      "systemsettingsrc"."KFileDialog Settings"."detailViewIconSize" = 16;
      "systemsettingsrc"."systemsettings_sidebar_mode"."HighlightNonDefaultSettings" = true;
    };
  };
}
