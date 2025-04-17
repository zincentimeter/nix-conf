{ config, lib, inputs, ... }:

let
  flakeRepo = "/home/shinri/nix-conf";
in
{

  # A NixOS/nix helper
  programs.nh.enable = true;
  programs.nh.flake = flakeRepo;

  # can just call: , <app_name>
  # no longer require nix-shell -p mess
  programs.nix-index-database.comma.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "shinri" ];
    } // lib.optionalAttrs (inputs ? zincentimeter) {
      extra-substituters = [ "https://zincentimeter-nur.cachix.org" ];
      extra-trusted-public-keys = [ "zincentimeter-nur.cachix.org-1:lUnmYfaT5gswUYZOMBa7fFxSSLZb+aJGlTJFeCU7w5A=" ];
    };
    extraOptions = ''
      !include ${config.sops.templates."nix_access_token.conf".path}
    '';
  };
  
  # define the source of /etc/nixos
  environment.etc.nixos.source = flakeRepo; 
  # Shell aliases related to NixOS
  environment.shellAliases = {
    nix-conf = "nvim --cmd 'cd ${config.users.users.shinri.home}/nix-conf'";
  };
}
