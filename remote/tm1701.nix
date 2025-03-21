# This config is heavily based on ../configuration.nix
{ config, lib, ... }:
{
  imports = [
    ../configuration.nix
  ];
  # Boot
  boot.loader.systemd-boot.enable = lib.mkForce true;
  boot.lanzaboote.enable = lib.mkForce false;
  # Hardware
  # don't use open driver on tm1701
  hardware.nvidia.open = lib.mkForce false;
  # Network
  networking.hostName = lib.mkForce "tm1701";
  # Home manager
  home-manager.users.shinri = {
    # Touchpad change (but don't use mkForce)
    programs.plasma.input.touchpads = [{
      vendorId = "04f3";
      productId = "3083";
      name = "ETD2303:00 04F3:3083 Touchpad";
      enable = true;
      naturalScroll = true;
    }];
    # Use own ssh key instead
    programs.ssh.matchBlocks."*".identityFile = lib.mkForce
      "${config.users.users.shinri.home}/.ssh/tm1701";
    # disable texlive
    programs.texlive.enable = lib.mkForce false;
  };
  # Secrets
  sops.age.sshKeyPaths = lib.mkForce [ "${config.users.users.shinri.home}/.ssh/tm1701" ];
  # Services
  services.onedrive.enable = lib.mkForce false;
  # Printers are disabled
  services.printing.enable = lib.mkForce false;
  # Don't enable waydroid
  virtualisation.waydroid.enable = lib.mkForce false;

  # Open SSH
  services.openssh = {
    enable = true;
    ports = [ 22112 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkForce "prohibit-password";
    };
    hostKeys = [
      {
        path = "${config.users.users.shinri.home}/.ssh/tm1701";
        type = "ed25519";
      }
    ];
  };
}
