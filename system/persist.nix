{ lib, config, pkgs, ... }:

/* So far included:
 * /etc/secureboot
 * /etc/NetworkManager/system-connections
 * /etc/v2raya
 * /etc/nixos
 * /etc/adjtime
 * /etc/machine-id
 * /var/cache/fwupd
 * /var/lib/{nixos,private,systemd/{backlight,catalog,pstore,timers,coredump,rfkill,timesync,random-seed},NetworkManager,cups,AccountsService,alsa,bluetooth,fprint,fwupd,power-profiles-daemon,sddm,tailscale,udisks2,upower,logrotate.status,sops-nix}
 * /var/log/
 * /var/spool/cups

 * ~/{nix-conf,Collections,OneDrive,tmp}
 * /.config and ~/.local
 */

let
  # during the preparation, we set it to root,
  # after mount root to tmpfs, it will be set to something like /nix/persist.
  impermanence = {
    persistHome = "/nix/persist";
    storageHome = "/nix/storage";
  };

  user_full_only = "u=rwx,g=,o=";
  xdgRelative = {
    cacheHome = ".cache";
    configHome = ".config";
    dataHome = ".local/share";
    stateHome = ".local/state";
  };

  shinri = config.home-manager.users.shinri;
  atHome = package: (builtins.elem package shinri.home.packages);
in
{
  fileSystems."/nix".neededForBoot = true;

  environment.persistence = {
    "${impermanence.persistHome}" = {
      enable = true;
      hideMounts = true;
      directories = [
        { directory = "/tmp"; }
        { directory = "/var/tmp"; }
        { directory = "/var/lib/nixos"; }
        {
          directory = "/var/lib/private";
          mode = user_full_only;
        }
        # systemd enabled by default
        { directory = "/var/lib/systemd/backlight"; }
        { directory = "/var/lib/systemd/catalog"; }
        { directory = "/var/lib/systemd/pstore"; }
        { directory = "/var/lib/systemd/timers"; }
        # logging
        { directory = "/var/log"; }
      ] ++ lib.optionals (
        # This rely on having lanzaboote loaded
        (builtins.hasAttr "lanzaboote" config.boot) &&
        (config.boot.lanzaboote.enable)
      ) [
        { directory = "/etc/secureboot"; }
      ] ++ lib.optionals config.networking.networkmanager.enable [ 
        { directory = "/etc/NetworkManager/system-connections"; }
        { directory = "/var/lib/NetworkManager"; }
      # many borrowed from https://github.com/matthewpi/nixos-config
      ] ++ lib.optionals config.services.printing.enable [
        # CUPS printing service profiles
        { directory = "/var/lib/cups"; }
        {
          directory = "/var/spool/cups";
          group = "lp"; mode = "u=rwx,g=x,o=";
        }
      ] ++ lib.optionals config.services.v2raya.enable [ 
        # V2RayA default files:
        # https://v2raya.org/en/docs/prologue/installation/linux/
        { directory = "/etc/v2raya"; }
      ] ++ lib.optionals config.services.accounts-daemon.enable [
        { directory = "/var/lib/AccountsService"; }
      ] ++ lib.optionals config.services.pipewire.alsa.enable [
        { directory = "/var/lib/alsa"; }
      ] ++ lib.optionals config.hardware.bluetooth.enable [
        { 
          directory = "/var/lib/bluetooth";
          mode = user_full_only;
        }
      ] ++ lib.optionals config.services.hardware.bolt.enable [
        { directory = "/var/lib/boltd"; }
      ] ++ lib.optionals config.services.fprintd.enable [
        {
          directory = "/var/lib/fprint";
          mode = user_full_only;
        }
      ] ++ lib.optionals config.services.fwupd.enable [
        { directory = "/var/cache/fwupd"; }
        {
          directory = "/var/lib/fwupd";
          user = "fwupd-refresh"; group = "fwupd-refresh";
        }
      ] ++ lib.optionals (config.systemd.nspawn != {}) [
        {
          directory = "/var/lib/machines";
          mode = user_full_only;
        }
      ] ++ lib.optionals config.services.power-profiles-daemon.enable [
        { directory = "/var/lib/power-profiles-daemon"; }
      ] ++ lib.optionals config.services.ollama.enable [
        {
          directory = "/var/lib/private/ollama";
          user = "ollama"; group = "ollama";
        }
      ] ++ lib.optionals config.services.syncthing.relay.enable [
        {
          directory = "/var/lib/private/syncthing-relay";
        }
      ] ++ lib.optionals config.services.displayManager.sddm.enable [
        {
          directory = "/var/lib/sddm";
          user = "sddm"; group = "sddm";
          mode = user_full_only;
        }
      ] ++ lib.optionals config.systemd.coredump.enable [
        { directory = "/var/lib/systemd/coredump"; }
      ] ++ lib.optionals (
        config.networking.wireless.enable ||
        config.hardware.bluetooth.enable
      ) [
        { directory = "/var/lib/systemd/rfkill"; }
      ] ++ lib.optionals config.services.timesyncd.enable [
        {
          directory = "/var/lib/systemd/timesync";
          user = "systemd-timesync"; group = "systemd-timesync";
        }
      ] ++ lib.optionals config.services.tailscale.enable [
        {
          directory = "/var/lib/tailscale";
          mode = user_full_only;
        }
      ] ++ lib.optionals config.services.udisks2.enable [
        { directory = "/var/lib/udisks2"; }
      ] ++ lib.optionals config.services.upower.enable [
        { directory = "/var/lib/upower"; }
      ] ++ lib.optionals config.virtualisation.waydroid.enable [
        { directory = "/var/lib/waydroid"; }
      ];
      # Files (symlink included)
      files = [
        { file = "/var/lib/systemd/random-seed"; }
        # man 5 adjtime_config
        { file = "/etc/adjtime"; }
        # man 5 machine-id
        { file = "/etc/machine-id"; }
      ] ++ lib.optionals config.services.logrotate.enable [
        { file = "/var/lib/logrotate.status"; }
      ] ++ lib.optionals config.services.printing.enable [
        { file = "/etc/printcap"; }
      ] ++ lib.optionals (builtins.pathExists config.sops.age.keyFile) [
        { file = config.sops.age.keyFile; }
      ] ++ lib.optionals config.users.mutableUsers [
        # https://nixos.org/manual/nixos/stable/#ch-system-state
        { file = "/etc/passwd"; }
        { file = "/etc/group"; }
        { file = "/etc/shadow"; }
        { file = "/etc/subuid"; }
        { file = "/etc/subgid"; }
      ];

      users.shinri =
      let
        configHome = xdgRelative.configHome;
        dataHome = xdgRelative.dataHome;
        stateHome = xdgRelative.stateHome;
      in
      {
        directories = [
          # The right repository of nix-conf
          "nix-conf"
          # Secure keys related
          { directory = ".ssh"; mode = user_full_only; }
          { directory = ".gnupg"; mode = user_full_only; }
          # Nix States
          "${stateHome}/nix"
          # Cache Home (just saves it for fast access)
          "${xdgRelative.cacheHome}"
          # Autostart applications (like telegram)
          "${configHome}/autostart"
          # apps like Foliate require GNOME-flavored settings
          "${configHome}/dconf"
          # GitHub CLI (used without installed)
          "${configHome}/gh"
          # Fonts
          "${dataHome}/fonts"
        ] ++ lib.optionals config.virtualisation.waydroid.enable [
          "${dataHome}/waydroid"
        ] ++ lib.optionals (atHome pkgs.tldr) [
          "${dataHome}/tldrc" # then tldrc symlink -> ~/.tldrc
          # symlink managed in home/files.nix
        ] ++ lib.optionals (
          config.programs.firefox.enable ||
          shinri.programs.firefox.enable
        )[
          ".mozilla"
        ] ++ lib.optionals (
          config.programs.thunderbird.enable /* NixOS */ ||
          shinri.programs.thunderbird.enable /* home  */
        ) [
          ".thunderbird"
        ] ++ lib.optionals (atHome pkgs.oama) [
          "${configHome}/oama"
        ] ++ lib.optionals (atHome pkgs.remmina) [
          "${configHome}/freerdp"
          "${configHome}/remmina"
          "${dataHome}/remmina"
        ] ++ lib.optionals (atHome pkgs.obs-studio) [
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
          shinri.programs.fish.enable
        ) [
          "${configHome}/fish"
          "${dataHome}/fish"
        ] ++ lib.optionals config.programs.steam.enable [
          # (Some gave saves sit on it)
          "${configHome}/unity3d"
          "${configHome}/Steam"
          "${dataHome}/Steam"
        ] ++ lib.optionals (atHome pkgs.cinny-desktop) [
          "${dataHome}/cinny"
          "${dataHome}/in.cinny.app"
        ] ++ lib.optionals (atHome pkgs.telegram-desktop) [
          "${dataHome}/TelegramDesktop"
        ] ++ lib.optionals (atHome pkgs.osu-lazer-bin) [
          "${dataHome}/osu"
        ] ++ lib.optionals (atHome pkgs.prismlauncher) [
          "${dataHome}/PrismLauncher"
        ] ++ lib.optionals (atHome pkgs.vlc) [
          "${dataHome}/vlc"
        ] ++ lib.optionals (atHome pkgs.stra.wemeet) [
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
        ] ++ lib.optionals (atHome pkgs.zotero_7 || atHome pkgs.zotero) [
          "${configHome}/zotero"
          "${dataHome}/zotero"
        ] ++ lib.optionals (
          config.programs.neovim.enable ||
          shinri.programs.neovim.enable
        ) [
          "${dataHome}/nvim"
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
        files = [ 
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
      }; # users.shinri
    }; # "${impermanence.persistHome}"
    "${impermanence.storageHome}" = {
      enable = true;
      hideMounts = true;
      directories = [];
      files = [];
      users.shinri = {
        directories = [
          "OneDrive"
          "Collections"
          "tmp"
        ];
      }; # users.shinri
    }; # "${impermanence.storageHome}"
  }; # environment.persistence
}
