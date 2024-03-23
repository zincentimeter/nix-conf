# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Home folder
      # (./home/default.nix will be imported)
      ./home

      # Sound / Graphic cards / Printers / Peripherals / etc.
      # (./hardware/default.nix will be imported)
      ./hardware

      # Boot / Disk (Disko) / GUI / Hardware scan
      # (./system/default.nix will be imported)
      ./system
    ];

  sops = {
    defaultSopsFile = ./secrets.json;
    defaultSopsFormat = "json";
    age = {
      sshKeyPaths = [ "${config.users.users.shinri.home}/.ssh/thinkpad_nixos" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets.github_access_token = {};

    templates."nix_access_token.conf".content = ''
      access-tokens = github.com=${config.sops.placeholder.github_access_token}
    '';
  };

  networking.hostName = "thinkpad-p16v"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.supportedLocales = [ "all" ];
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5 = {
    addons = with pkgs; [ fcitx5-rime fcitx5-mozc fcitx5-gtk ];
  };

  # Proxy
  services.v2raya.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "shinri" ];
  nix.extraOptions = ''
    !include ${config.sops.templates."nix_access_token.conf".path}
  '';
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shinri = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      telegram-desktop
      cinny-desktop
      obs-studio
      
      # For coq, a language used in software foundation book
      coq
      coqPackages.vscoq-language-server

      # game
      # minecraft
      prismlauncher
    ];
  };

  # game: steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;
    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = true;
    # missing dependency packages (use if required)
    # package = pkgs.steam.override {
    #   withPrimus = true;
    #   withJava = true;
    #   extraPkgs = with pkgs; [
    #     bumblebee
    #     glxinfo
    #   ];
    # };

  };

  # programs.java.enable = true;
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    tldr

    noto-fonts-cjk

    # Processes output of Nix commands to show helpful and pretty information
    nix-output-monitor
    # Language Server for Nix
    nil

    # Shell (mainly for `fish`) plugins
    # A utility tool powered by fzf for using git interactively.
    fishPlugins.forgit
    # A command-line fuzzy finder written in Go
    fzf

  ];

  # Font
  fonts.packages = with pkgs; [
    redhat-official-fonts
    nerdfonts
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Red Hat Mono"
      "DejaVu Sans Mono"
    ];
  };

  # Editor configuration
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    configure = {
      customRC = ''
        set number relativenumber
        lua require 'lspconfig'.nil_ls.setup{}
      '';
      packages.myVimPackage.start = with pkgs.vimPlugins; [
        nvim-lspconfig
      ];
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.ssh.startAgent = true;

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Shell aliases
  environment.shellAliases = {
    gnix = "git --work-tree=${config.users.users.shinri.home}/nix-conf";
    ns = "sudo nixos-rebuild switch";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
