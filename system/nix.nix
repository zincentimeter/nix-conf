{ config, ... }:

{
  # can just call: , <app_name>
  # no longer require nix-shell -p mess
  programs.nix-index-database.comma.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "shinri" ];
    };
    extraOptions = ''
      !include ${config.sops.templates."nix_access_token.conf".path}
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
  
  # define the source of /etc/nixos
  environment.etc.nixos.source = "/home/shinri/nix-conf";
  # Shell aliases related to NixOS
  environment.shellAliases = {
    gnix = "git --work-tree=${config.users.users.shinri.home}/nix-conf";
    nix-conf = "nvim --cmd 'cd ${config.users.users.shinri.home}/nix-conf'";
    ns = "sudo nixos-rebuild switch";
    nb = "sudo nixos-rebuild boot";
  };
}
