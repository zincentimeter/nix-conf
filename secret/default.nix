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
    
    secrets =
      builtins.mapAttrs (_: v: v // {
          mode = "0440";
          owner = config.users.users.shinri.name;
          group = config.users.users.shinri.group;
        }
      ) {
        # Secrets listed here are managed and readable by user <shinri>.
        "rclone_azure_token" = {};
        "rclone_client_secret_value" = {};
        "rclone_client_secret_secret_id" = {};
        "outlook_password" = {};
        "campus_password" = {};
      } // {
        # Secrets listed here requires elevated permission.
        "github_access_token" = {};
        "onedrive_fuse_azure_token" = {};
      };
    templates."nix_access_token.conf".content = ''
      access-tokens = github.com=${config.sops.placeholder.github_access_token}
    '';
  };

}
