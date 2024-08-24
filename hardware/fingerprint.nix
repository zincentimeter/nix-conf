{ config, ... }:

{
  # Fingerprint
  services.fprintd.enable = true;
  security.pam.services = 
    builtins.mapAttrs (_: v: v // {
        nodelay = true;
        fprintAuth = config.services.fprintd.enable;
      }
    ) {
      chfn = {}; chpasswd = {}; chsh = {};
      fprintd = {};
      groupadd = {}; groupdel = {}; groupmems = {}; groupmod = {};
      i3lock = {}; i3lock-color = {};
      other = {};
      passwd = {};
      runuser = {}; runuser-l = {};
      systemd-user = {};
      useradd = {}; userdel = {}; usermod = {};
      vlock = {}; xlock = {}; xscreensaver = {};
    } //
    builtins.mapAttrs (_: v: v // {
        nodelay = true;
        fprintAuth = false;
      }
    ) {
      # Always disable fprintAuth on polkit-1, sddm
      polkit-1 = {};
      sddm = {}; sddm-autologin = {}; sddm-greeter = {};
      kde = {};
      login = {};
      su = {}; sudo = {};
    };
}
