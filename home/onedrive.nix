{ config, pkgs, ... }:

let
  # The mount path of my OneDrive
  mountPath = "${config.home.homeDirectory}/OneDrive";
  configName = "rclone/config.toml";
  configPath = "${config.xdg.configHome}/${configName}";
in
{
  # To use, 
  # 1. Register an app 
  # > https://github.com/oxalica/onedrive-fuse/blob/main/doc/register_app.md
  # 2. Login to follow
  # > https://github.com/oxalica/onedrive-fuse/blob/main/README.md
  home.packages = with pkgs; [
    rclone
  ];

  # The config is saved at ${configPath}. since its managed by rclone
  # i will not take over it.
  # To configure, use /var/secrets/
  # "rclone" is the name of the new service we'll be creating
  systemd.user.services."rclone" = {
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
      ExecStart = ''${pkgs.rclone}/bin/rclone mount ${mountPath}'';
      ExecStop = ''${pkgs.rclone}/bin/fusermount -u ${mountPath}'';
    };
  };
}