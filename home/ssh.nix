{ config, ... }:

let
  homeDirectory = config.home.homeDirectory;
in
{
  programs.ssh = {
    enable = true;
  };
}