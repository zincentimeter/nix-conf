{ config, lib, pkgs, inputs, ... }:

{
  # Program configured with home-manager, but as a NixOS module!
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

    users.shinri = {
      # Home Manager needs a bit of information about you and the
      # paths it should manage.
      home.username = config.users.users.shinri.name;
      home.homeDirectory = config.users.users.shinri.home;
      home.packages = with pkgs; [
        tree
        telegram-desktop

        # tldr, too long, don't read, cmd quick lookup
        tlrc

        # remote desktop
        remmina

        # zotero
        zotero_7

        # PDF / ePub reader
        foliate

        # If you use KDE (Plasma) then you'll be better off with libreoffice-qt package.
        # Otherwise you may lack, e.g. main menu bar. 
        libreoffice-qt

        # BT downloading
        qbittorrent

        # Game
        osu-lazer-bin
        # An Project Diva Modding Manager
        rust4diva
        # minecraft
        prismlauncher

        # Clipboard for Neovim to access system clipboard.
        wl-clipboard

        # OAuth my Outlook
        oama
        # library for storing password (initally used by oama)
        libsecret

        # Tencent Meeting
        wemeet
        # Zoom-us video conferencing
        zoom-us

        # watchalong
        # syncplay
        stra.vlc-wayland

        # trading
        tradingview
        ib-tws

        # player
        mpv

        # ftp over ssl
        filezilla

        # Notetaking
        xournalpp

        # markdown
        typora
        obsidian

        # bruh
        wechat-uos

        # monitor
        # top-like monitor
        btop
        # systemd tui
        isd
        # graphical monitor
        nvitop
        # strace alternative
        lurk

        # bruh
        shtech-net-loginer

        # password manager
        keepassxc
      ];

      imports = [
        ./files.nix
        ./firefox.nix
        ./email.nix
        ./plasma
        ./terminal.nix
        ./neovim
        ./git.nix
        ./shell.nix
        ./typeset.nix
        ./mime.nix
      ] ++ lib.optional (builtins.pathExists ./ssh.nix) ./ssh.nix;


      # A NixOS/nix helper
      programs.nh = {
        enable = true;
        flake = "/home/shinri/nix-conf";
      };

      programs.bat.enable = true;

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          # screen capture on wlroots based wayland compositors
          wlrobs
          # browser source, as official source does not work
          obs-webkitgtk
          # show keyboard on stream
          input-overlay
        ];
      };

      services.tldr-update = {
        enable = true;
        package = pkgs.tlrc;
      };
      # This value determines the home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update home Manager without changing this value. See
      # the home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "23.11";
    };
  };
}
