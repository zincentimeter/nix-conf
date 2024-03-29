{ config, pkgs, ... }:

let
  # The mount path of my OneDrive
  mountPath = "${config.home.homeDirectory}/OneDrive";
  configName = "onedrive-fuse/config.toml";
  configPath = "${config.xdg.configHome}/${configName}";
in
{
  # To use, 
  # 1. Register an app 
  # > https://github.com/oxalica/onedrive-fuse/blob/main/doc/register_app.md
  # 2. Login to follow
  # > https://github.com/oxalica/onedrive-fuse/blob/main/README.md
  home.packages = with pkgs; [
    onedrive-fuse
    fuse
  ];

  # The cookie may outdate, I have placed the azure token under ./secret/ with sops-nix
  # To login for the first time:
  # > onedrive-fuse login --read-write --client-id $(sudo cat /run/secrets/onedrive_fuse_azure_token)
  # If ~/.config/onedrive-fuse/credential.json exists, then simply run
  # > onedrive-fuse login --read-write

  xdg.configFile.${configName}.source = ./onedrive.toml;

  # "onedrive-fuse" is the name of the new service we'll be creating
  systemd.user.services."onedrive-fuse" = {
    Unit = {
      After = ["network.target" "sound.target"];
      Description = "Mount Microsoft OneDrive storage as FUSE filesystem";
    };
    # set it to ["default.target"] to make a unit start by default when the user <name> logs on.
    Install.WantedBy = [ "default.target" ];
    Service = {
      # see systemd man pages for more information on the various options for "Type": "notify"
      # specifies that this is a service that waits for notification from its predecessor (declared in
      # `after=`) before starting
      Type = "notify";
      ExecStart = ''${pkgs.onedrive-fuse.outPath}/bin/onedrive-fuse mount ${mountPath} --config ${configPath}'';
      ExecStop = ''${pkgs.fuse.outPath}/bin/fusermount -u ${mountPath}'';
    };
  };
}