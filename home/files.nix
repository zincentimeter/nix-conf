{ config, ... }:

let
  mkDirSymlink = (sourcePath : {
    source = config.lib.file.mkOutOfStoreSymlink sourcePath;
    recursive = true;
  });
  onedrive = "${config.home.homeDirectory}/OneDrive";
in
{
  # File Layout
  home.file =
  {
    "Documents" = mkDirSymlink "${onedrive}/Documents";
    "Pictures" = mkDirSymlink "${onedrive}/图片";
    "Videos" = mkDirSymlink "${onedrive}/视频";
    "Music" = mkDirSymlink "${onedrive}/music";
    ".zotero" = mkDirSymlink "${config.xdg.configHome}/zotero";
    ".steam" = mkDirSymlink "${config.xdg.configHome}/Steam";
    ".xwechat" = mkDirSymlink "${config.xdg.dataHome}/wechat";
  };

}
