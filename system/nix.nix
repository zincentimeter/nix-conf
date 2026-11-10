{ config, lib, inputs, ... }:

{
  # can just call: , <app_name>
  # no longer require nix-shell -p mess
  programs.nix-index-database.comma.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    # by zotero-10.0.6 due to firefox ESR 140 EOL
    # Related:
    # - https://github.com/NixOS/nixpkgs/pull/572466
    # - https://github.com/NixOS/nixpkgs/issues/579749
    "firefox-esr-140-bin-unwrapped-140.17.0esr"
  ];

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
