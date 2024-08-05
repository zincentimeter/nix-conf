{ ... }:

{
  programs.plasma.configFile = {
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
}
