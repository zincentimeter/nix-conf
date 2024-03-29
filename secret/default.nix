{ config, ... }:

{
  sops = {
    defaultSopsFile = ./secrets.json;
    defaultSopsFormat = "json";
    age = {
      sshKeyPaths = [ "${config.users.users.shinri.home}/.ssh/thinkpad_nixos" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets.github_access_token = {};
    secrets.onedrive_fuse_azure_token = {};
    
    templates."nix_access_token.conf".content = ''
      access-tokens = github.com=${config.sops.placeholder.github_access_token}
    '';
  };

}