{ config, ... }:

let
  # The mount path of my OneDrive
  mountRootPath = "${config.home.homeDirectory}/OneDrive";
in
{
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
