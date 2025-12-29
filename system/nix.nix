{ config, lib, inputs, ... }:

{
  # can just call: , <app_name>
  # no longer require nix-shell -p mess
  programs.nix-index-database.comma.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "ca-derivations"
      ];
      accept-flake-config = true;
      auto-allocate-uids = true;
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
    } // lib.optionalAttrs (inputs ? zincentimeter) {
      extra-substituters = [ "https://zincentimeter-nur.cachix.org" ];
      extra-trusted-public-keys = [ "zincentimeter-nur.cachix.org-1:lUnmYfaT5gswUYZOMBa7fFxSSLZb+aJGlTJFeCU7w5A=" ];
    };
    extraOptions = ''
      !include ${config.sops.templates."nix_access_token.conf".path}
    '';
  };

  # Shell aliases related to NixOS
  environment.shellAliases = {
    nix-conf = "nvim --cmd 'cd ${config.users.users.shinri.home}/nix-conf'";
    nf = "nix-conf";
  };
}
