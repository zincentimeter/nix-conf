{ config, lib, pkgs, ... }:

/*
 * ~/{nix-conf,Collections,OneDrive,tmp}
 * /.config and ~/.local
 */

let
  fileSource = {
    persistHome = "/nix/persist";
    storageHome = "/nix/storage";
  };
  user_full_only = "u=rwx,g=,o=";
  # Home-related
  username = "shinri";
  atHome = package: (builtins.elem
    package
    config.home-manager.users.${username}.home.packages
  );
  xdgRelative = {
    cacheHome = ".cache";
    configHome = ".config";
    dataHome = ".local/share";
    stateHome = ".local/state";
  };
  user = config.home-manager.users.${username};
in
{
  environment.persistence = {
    "${fileSource.persistHome}" = {
      users.${username} = {
        directories = with xdgRelative; [
          # The right repository of nix-conf
          "nix-conf"
          # Secure keys related
          { directory = ".ssh"; mode = user_full_only; }
          { directory = ".gnupg"; mode = user_full_only; }
          # Nix States
          "${stateHome}/nix"
          # Cache Home (just saves it for fast access)
          "${cacheHome}"
          # Autostart applications (like telegram)
          "${configHome}/autostart"
          # apps like Foliate require GNOME-flavored settings
          "${configHome}/dconf"
          # GitHub CLI (used without installed)
          "${configHome}/gh"
          # Fonts
          "${dataHome}/fonts"
        ##########################################################
        # ADD HOME HERE
        # 1. with options:
        # ++ lib.optionals {config,shinri}.programs.*.enable [
        # 2. with packages written in home/:
        # ++ lib.optionals (atHome pkgs.*) [
        #
        ##########################################################
        ] ++ lib.optionals (atHome pkgs.keepassxc) [
          "${configHome}/keepassxc"
        ] ++ lib.optionals (atHome pkgs.wechat-uos || atHome pkgs.wechat) [
          "${dataHome}/wechat"
        ] ++ lib.optionals (atHome pkgs.obsidian) [
          "${configHome}/obsidian"
        ] ++ lib.optionals (atHome pkgs.typora) [
          "${configHome}/Typora"
        ] ++ lib.optionals (atHome pkgs.filezilla) [
          "${configHome}/filezilla"
          "${cacheHome}/filezilla"
        ] ++ lib.optionals config.virtualisation.waydroid.enable [
          "${dataHome}/waydroid"
        ] ++ lib.optionals (atHome pkgs.tlrc) [
          "${cacheHome}/tlrc"
        ] ++ lib.optionals (
          config.programs.firefox.enable ||
          user.programs.firefox.enable
        )[
          ".mozilla"
        ] ++ lib.optionals (
          config.programs.thunderbird.enable /* NixOS */ ||
          user.programs.thunderbird.enable /* home  */
        ) [
          ".thunderbird"
        ] ++ lib.optionals (atHome pkgs.remmina) [
          "${configHome}/freerdp"
          "${configHome}/remmina"
          "${dataHome}/remmina"
        ] ++ lib.optionals (
          atHome pkgs.obs-studio ||
          config.programs.obs-studio.enable /* NixOS */ ||
          user.programs.obs-studio.enable /* home */
        ) [
          "${configHome}/obs-studio"
        ] ++ lib.optionals (config.services.onedrive.enable) [
          "${configHome}/onedrive"
        ] ++ lib.optionals (atHome pkgs.qbittorrent) [
          "${configHome}/qBittorrent"
          "${dataHome}/qBittorrent"
        ] ++ lib.optionals (config.services.syncthing.enable) [
          "${configHome}/syncthing"
        ] ++ lib.optionals (
          config.programs.fish.enable ||
          user.programs.fish.enable
        ) [
          "${configHome}/fish"
          "${dataHome}/fish"
        ] ++ lib.optionals config.programs.steam.enable [
          # (Some gave saves sit on it)
          "${configHome}/unity3d"
          "${configHome}/Steam"
          "${dataHome}/Steam"
          "${dataHome}/Euro Truck Simulator 2"
        ] ++ lib.optionals (atHome pkgs.telegram-desktop) [
          "${dataHome}/TelegramDesktop"
        ] ++ lib.optionals (atHome pkgs.osu-lazer-bin) [
          "${dataHome}/osu"
        ] ++ lib.optionals (atHome pkgs.prismlauncher) [
          "${dataHome}/PrismLauncher"
        ] ++ lib.optionals (atHome pkgs.vlc) [
          "${dataHome}/vlc"
        ] ++ lib.optionals (atHome pkgs.wemeet) [
          "${dataHome}/wemeetapp"
        ] ++ lib.optionals (
          config.i18n.inputMethod.enable &&
          (config.i18n.inputMethod.type == "fcitx5")
        ) [
          "${configHome}/fcitx"
          "${configHome}/fcitx5"
          "${dataHome}/fcitx5"
        ] ++ lib.optionals (
          config.i18n.inputMethod.enable &&
          (config.i18n.inputMethod.type == "fcitx5") &&
          (builtins.elem
            pkgs.fcitx5-mozc config.i18n.inputMethod.fcitx5.addons)
        ) [
          # Japanese IME
          "${configHome}/mozc"
        ] ++ lib.optionals (atHome pkgs.zotero) [
          "${configHome}/zotero"
          "${dataHome}/zotero"
        ] ++ lib.optionals (
          config.programs.neovim.enable ||
          user.programs.neovim.enable
        ) [
          "${dataHome}/nvim"
          "${stateHome}/nvim"
        ] ++ [
          # KDE (not governed by plasma-manager)
          # - kdeconnect
          "${configHome}/kdeconnect"
          # - baloo file index
          "${dataHome}/baloo"
          # - KActivities
          "${dataHome}/kactivitymanagerd"
          "${dataHome}/kwalletd"
          # - Okular (Bookmark, etc.)
          "${dataHome}/okular"
          # - Widgets
          "${dataHome}/plasma/plasmoids"
          # - Dolphin remote folders
          "${dataHome}/remoteview"
          # - Trash bin (used by Dolphin)
          "${dataHome}/Trash"
        ];
        files = with xdgRelative; [
          # sops-nix
          "${configHome}/sops/age/keys.txt"
        ] ++ lib.optionals (atHome pkgs.syncplay) [
          "${configHome}/syncplay.ini"
        ] ++ [
          # KDE (not governed by plasma-manager)
          # - KWin Display Configuration
          "${configHome}/kwinoutputconfig.json"
          # - Dolphin's User Bookmark (sidebar)
          "${dataHome}/user-places.xbel"
        ];
      }; # users.${username}
    }; #"${fileSource.persistHome}"

    "${fileSource.storageHome}" = {
      enable = true;
      hideMounts = true;
      directories = [];
      files = [];
      users.${username} = {
        directories = [
          "OneDrive"
          "Collections"
          "tmp"
        ];
      }; # users.shinri
    }; # "${impermanence.storageHome}"
  }; # environment.persistence
}
