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
    programs.plasma.input.touchpads = [{
      vendorId = "04f3";
      productId = "3083";
      name = "ETD2303:00 04F3:3083 Touchpad";
      enable = true;
      naturalScroll = true;
    }];
    programs.ssh.matchBlocks."*".identityFile = lib.mkForce
      "${config.users.users.shinri.home}/.ssh/tm1701";
  };
  # Secrets
  sops.age.sshKeyPaths = lib.mkForce [ "${config.users.users.shinri.home}/.ssh/tm1701" ];
  # Services
  services.onedrive.enable = lib.mkForce false;
}
