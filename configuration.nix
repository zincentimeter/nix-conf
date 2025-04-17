# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, inputs, ... }:

{
  imports =
    [
      # Home folder
      # (./home/default.nix will be imported)
      ./home

      # Sound / Graphic cards / Printers / Peripherals / etc.
      # Hardware scan (hardware-configuration.nix is also included in it)
      # (./hardware/default.nix will be imported)
      ./hardware

      # Boot / Disk (Disko) / GUI / Locale / Environment (Shells) for all users
      # (./system/default.nix will be imported)
      ./system

      # Secret-related configure
      ./secret

      # Applications
      ./service
    ];

  # game: steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;
    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
  ];

  # Patching nixpkgs with customized packages
  # e.g. apps from other sources or stable branch
  nixpkgs.overlays = [
    inputs.stratosphere.overlays.default
    # Overlay function below
    (final: prev:
    {
      # Apple Fonts
      inherit (inputs.apple-fonts.packages."x86_64-linux")
        sf-pro sf-compact sf-mono sf-arabic ny
      ;
      # NaiveProxy
      inherit (inputs.sn0wm1x.packages."x86_64-linux")
        naiveproxy-bin
      ;
      # My NUR
      inherit (inputs.zincentimeter.packages."x86_64-linux")
        rust4diva
      ;

      # 2025/04/17
      # PR#399231 has been merged to master but not into unstable for now
      inherit (inputs.nixpkgs-master.legacyPackages."x86_64-linux")
        oama
      ;
    })
  ]; # overlays

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
