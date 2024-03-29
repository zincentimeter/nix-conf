{ pkgs, ... }:

let
  # The mount path of my OneDrive
  mountPath = "/home/shinri/OneDrive";
in 
{
  # To use, 
  # 1. Register an app 
  # > https://github.com/oxalica/onedrive-fuse/blob/main/doc/register_app.md
  # 2. Login to follow
  # > https://github.com/oxalica/onedrive-fuse/blob/main/README.md
  environment.systemPackages = [
    pkgs.onedrive-fuse
    pkgs.fuse
  ];

  # The cookie may outdate, I have placed the azure token under ./secret/ with sops-nix
  # To login for the first time:
  # > onedrive-fuse login --read-write --client-id $(sudo cat /run/secrets/onedrive_fuse_azure_token)
  # If ~/.config/onedrive-fuse/credential.json exists, then simply run
  # > onedrive-fuse login --read-write

  # "onedrive-fuse" is the name of the new service we'll be creating
  systemd.user.services."onedrive-fuse" = {
    enable = true;
    after = ["network.target" "sound.target"];
    # set it to ["default.target"] to make a unit start by default when the user <name> logs on.
    wantedBy = [ "default.target" ];
    description = "Mount Microsoft OneDrive storage as FUSE filesystem";
    serviceConfig = {
      # see systemd man pages for more information on the various options for "Type": "notify"
      # specifies that this is a service that waits for notification from its predecessor (declared in
      # `after=`) before starting
      Type = "notify";
      ExecStart = ''${pkgs.onedrive-fuse.outPath}/bin/onedrive-fuse mount ${mountPath}'';
      ExecStop = ''${pkgs.fuse.outPath}/bin/fusermount -u ${mountPath}'';
    };
  };
}