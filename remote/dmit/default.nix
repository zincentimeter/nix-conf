{ inputs, config, lib, pkgs, ... }:

# Mostly copied and interpreted from
# https://lantian.pub/article/modify-computer/nixos-low-ram-vps.lantian/
# And some are from the existing config of DMIT's default settings

{

  imports = [
    # 1, Boot Options
    ./boot.nix
    # 4. Networking
    ./network.nix
    # 5. Disko
    ./disko.nix
    # 6. sing-box Configuration
    ./sing-box.nix
    # 7. open-webui
    ./open-webui.nix
  ];

  #####################
  ## 2. Miscallenous ##
  #####################

  # TimeZone follows the previous installation, which is UTC
  time.timeZone = "Etc/UTC";

  ######################
  ## 3. Users and SSH ##
  ######################

  users.mutableUsers = false;
  users.users.root = {
    hashedPassword = "$6$7me7EXRp1tvnOwaR$7KM89ZksnUc4MFNA2n66I972hvzbUmm/BmA6a1bLTjrUeXHMsRbYuj9OiO4.BXabgm6u8wwlCRuzmgIPCPEQe0";
    openssh.authorizedKeys.keyFiles = [
      inputs.sourcehut-keys.outPath
    ];
  };

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
        path = "/nix/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  ###############################
  ## 7. secrets                 #
  ###############################

  sops = {
    defaultSopsFile = ./secrets.json;
    defaultSopsFormat = "json";
    age = {
      sshKeyPaths = [ "/nix/persist/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      "cloudflare_api_key" = {};
      "cloudflare_email" = {};
    };
  };

  security.acme = {
    acceptTerms = true;
    useRoot = true;
    defaults = {
      dnsPropagationCheck = true;
      email = "zincentimeter@outlook.com";
    };
    certs."dmit.zince.net" = {
      dnsProvider = "cloudflare";
      extraDomainNames = [ "dmit6.zince.net" ];
      credentialFiles = {
        "CLOUDFLARE_EMAIL_FILE" = config.sops.secrets.cloudflare_email.path;
        "CLOUDFLARE_API_KEY_FILE" = config.sops.secrets.cloudflare_api_key.path;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    btop
  ];

  #####################
  ## -1. Nix Related ##
  #####################

  system.stateVersion = "24.05";
}
