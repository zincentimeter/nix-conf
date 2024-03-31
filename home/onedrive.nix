{ config, pkgs, ... }:

let
  # The mount path of my OneDrive
  mountRootPath = "${config.home.homeDirectory}/OneDrive";
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
          After = [ "network.target" "sound.target"  ];
          Description = "Mount Microsoft OneDrive storage as FUSE filesystem, ${source} -> ${target}";
        };
        # set it to ["default.target"] to make a unit start by default when the user <name> logs on.
        Install.WantedBy = [ "xdg-desktop-portal.service" ];
        Service = {
          # see systemd man pages for more information on the various options for "Type": "notify"
          # specifies that this is a service that waits for notification from its predecessor (declared in
          # `after=`) before starting
          Type = "notify";

          ExecStart =
          let
            vfsCacheOption = "--vfs-cache-mode=writes";
            mountCommand = "${pkgs.rclone}/bin/rclone mount ${vfsCacheOption}";
          in
          ''
            ${mountCommand} ${source} ${target}
          '';
          ExecStop = ''${pkgs.fuse}/bin/fusermount -u ${target}'';
        };
      });
    in
  {
    "onedrive@root" = mkRcloneService { source = "OneDrive:"; target = mountRootPath; };
    "onedrive@videos" = mkRcloneService { source = "OneDrive:视频/"; target = config.xdg.userDirs.videos; };
    "onedrive@pictures" = mkRcloneService { source = "OneDrive:图片/"; target = config.xdg.userDirs.pictures; };
    "onedrive@documents" = mkRcloneService { source = "OneDrive:Documents/"; target = config.xdg.userDirs.documents; };
    "onedrive@music" = mkRcloneService { source = "OneDrive:music/"; target = config.xdg.userDirs.music; };
  };
}