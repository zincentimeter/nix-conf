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
        cinny-desktop
        obs-studio
        
        # For coq, a language used in software foundation book
        coq
        coqPackages.vscoq-language-server

        # tldr, too long, don't read, cmd quick lookup
        tldr

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
        # osu!
        osu-lazer-bin
        # minecraft
        prismlauncher

        # Clipboard for Neovim to access system clipboard.
        wl-clipboard

        # OAuth my Outlook
        mailctl

        # Tencent Meeting
        stra.wemeet

        # watchalong
        syncplay
        vlc
      ];

      imports = [
        ./files.nix
        ./vscode.nix
        ./firefox.nix
        ./thunderbird.nix
        ./plasma
        ./kitty.nix
        ./neovim
        ./git.nix
      ] ++ lib.optional (builtins.pathExists ./ssh.nix) ./ssh.nix;

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
