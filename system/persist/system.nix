{ config, lib, ... }:

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
 */

let
  fileSource = {
    persistHome = "/nix/persist";
    storageHome = "/nix/storage";
  };
  user_full_only = "u=rwx,g=,o=";
in
{
  fileSystems."/nix".neededForBoot = true;

  environment.persistence = {
    "${fileSource.persistHome}" = {
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
      ] ++ lib.optionals (config.security.acme.certs != {}) [
        { directory = "/var/lib/acme"; }
      ] ++ lib.optionals (
        # This rely on having lanzaboote loaded
        (builtins.hasAttr "lanzaboote" config.boot) &&
        (config.boot.lanzaboote.enable)
      ) [
        { directory = "/var/lib/sbctl"; }
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
    }; # "${fileSource.persistHome}"
  }; # environment.persistence
}
