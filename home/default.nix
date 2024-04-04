{ config, lib, pkgs, ... }:
let
  nvidiaOffloadSetting = [
    "--set __NV_PRIME_RENDER_OFFLOAD 1"
    "--set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0"
    "--set __GLX_VENDOR_LIBRARY_NAME nvidia"
    "--set __VK_LAYER_NV_optimus NVIDIA_only"
  ];
  # `qtWrapperArgs` only works for qt apps!
  # Read the derivative's source before apply override attribute!
  # We may even not see a warning on our overrided variables not being used.
  # Also, be sure to check the target of building
  # by going to the directory of newly-built one:
  # > readlink -f <the_binary_name>
  # check the file of that wrapper to see if it REALLY contains these variables.
  syncplayGpuOffloaded =
    pkgs.syncplay.overrideAttrs (finalAttrs: previousAttrs:
      {
        # https://github.com/NixOS/nixpkgs/issues/27769#issuecomment-318906426
        qtWrapperArgs = nvidiaOffloadSetting;
      }
    );
  vlcGpuOffloaded =
    pkgs.vlc.overrideAttrs (finalAttrs: previousAttrs:
      {
        qtWrapperArgs = nvidiaOffloadSetting;
      }
    );
in
{
  # Program configured with home-manager, but as a NixOS module!
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
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

        # game
        # minecraft
        prismlauncher

        # remote desktop
        remmina

        # zotero
        zotero_7

        # libreoffice
        # If you use KDE (Plasma) then you'll be better off with libreoffice-qt package.
        # Otherwise you may lack, e.g. main menu bar. 
        libreoffice-qt
      ] ++ [
        # watchalong
        syncplayGpuOffloaded
        vlcGpuOffloaded
      ];

      imports = [
        ./vscode.nix
        ./onedrive.nix
        ./firefox.nix
        ./thunderbird.nix
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