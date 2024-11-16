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
        "campus_password" = {};
        "azure_client_id" = {};
        "azure_client_secret" = {};
      } // {
        # Secrets listed here requires elevated permission.
        "github_access_token" = {};
      };

    templates."oama_config.yaml" = {
      mode = "0440";
      owner = config.users.users.shinri.name;
      group = config.users.users.shinri.group;
      content = ''
        encryption:
          tag: KEYRING
        services:
          microsoft:
            client_id: ${config.sops.placeholder.azure_client_id}
            client_secret: ${config.sops.placeholder.azure_client_secret}
      '';
    };

    templates."nix_access_token.conf".content = ''
      access-tokens = github.com=${config.sops.placeholder.github_access_token}
    '';
  };

}
