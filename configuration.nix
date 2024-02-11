# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
      ./disko.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad-p16v"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5 = {
    addons = with pkgs; [fcitx5-rime fcitx5-mozc fcitx5-gtk];
  };

  services.v2raya.enable = true;

  services.fprintd.enable = true;
  security.pam.services = 
    builtins.mapAttrs (n: v: v // {
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
    builtins.mapAttrs (n: v: v // {
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

  # Configure GUI here
  # programs.hyprland.enable = true;
  # hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # services.pipewire.enable = true;
  # programs.waybar.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
  };
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Graphic settings
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    powerManagement = {
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    	enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
	    finegrained = false;
    };

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    # shinri: my p16v has NVIDIA RTX A500 Laptop GPU, which comes with pci id 0x25BD
    # shinri: that means it can use the open one.
    open = true;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Hybrid Graphics (Nvidia Optimus PRIME)
    prime = {
      # Optimus Option C: Reverse Sync Mode (Experimental)
      reverseSync.enable = true;
      # Enable if using an external GPU
      allowExternalGpu = false;

      # Gathered from `lscpi -c display`
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    tldr

    # Hyprland
    # kitty
    # mako
    # xdg-desktop-portal-hyprland
    # hyprpaper
    # dolphin
    # wofi
    
    # Font
    redhat-official-fonts
    nerdfonts
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

  nixpkgs.config.allowUnfree = true;

  # Program configured with home-manager
  home-manager.users.shinri = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "shinri";
    home.homeDirectory = "/home/shinri";

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        maximedenes.vscoq
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "gitless";
          publisher = "maattdd";
          version = "11.7.2";
          sha256 = "rYeZNBz6HeZ059ksChGsXbuOao9H5m5lHGXJ4ELs6xc=";
        }
      ];
      userSettings = {
        "nix.serverPath" = "nil";
        "nix.enableLanguageServer" = true;
        "workbench.colorTheme" = "Default Dark Modern";
        "files.autoSave" = "afterDelay";
        "editor.fontFamily" = "'Red Hat Mono', 'Droid Sans Mono', 'monospace', monospace";
        "git.confirmSync" = false;
      };
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

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

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
  # users.users.shinri.shell = pkgs.fish;

  # Shell aliases
  environment.shellAliases = {
    gnix = "git --work-tree=/home/shinri/nix-conf";
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
