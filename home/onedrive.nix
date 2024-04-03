{ config, pkgs, ... }:

let
  # The mount path of my OneDrive
  mountRootPath = "${config.home.homeDirectory}/OneDrive";
  configName = "rclone/rclone.conf";
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
    fuse
  ];

  # The config is saved at ${configPath}. since its managed by rclone
  # i will not take over it.
  # To configure, use /var/secrets/
  # "rclone" is the name of the new service we'll be creating

  systemd.user.services = 
    let 
      mkRcloneService = ({source, target} : {
        Unit = {
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
          ConditionPathExists = [ "${configPath}" "${target}"];
          Description = "Mount Microsoft OneDrive storage as FUSE filesystem, ${source} -> ${target}";
        };
        # set it to ["default.target"] to make a unit start by default when the user <name> logs on.
        Install.WantedBy = [ "default.target" ];
        Service = {
          # see systemd man pages for more information on the various options for "Type": "notify"
          # specifies that this is a service that waits for notification from its predecessor (declared in
          # `after=`) before starting
          Type = "notify";

          ExecStart =
          let
            vfsCacheOption = "--vfs-cache-mode=full";
            mountCommand = "${pkgs.rclone}/bin/rclone mount ${vfsCacheOption}";
          in
          ''
            ${mountCommand} ${source} ${target}
          '';
          Restart = "on-failure";
          RestartSec = 30;
        };
      });
    in
  {
    "onedrive@root" = mkRcloneService { source = "OneDrive:"; target = mountRootPath; };
  };

  home.file = 
    let
      mkDirSymlink = (sourcePath : {
        source = config.lib.file.mkOutOfStoreSymlink sourcePath;
        recursive = true;
      });
    in
  {
    "Documents" = mkDirSymlink "${mountRootPath}/Documents";
    "Pictures" = mkDirSymlink "${mountRootPath}/图片";
    "Videos" = mkDirSymlink "${mountRootPath}/视频";
    "Music" = mkDirSymlink "${mountRootPath}/music";
  };
}
