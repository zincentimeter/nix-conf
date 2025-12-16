{ config, pkgs, lib, ... }:

let
  outlook = with config.accounts.email.accounts.outlook; {
    inherit address name;
    # https://meta.sr.ht/~zincentimeter.keys
    ssh = {
      publicKey = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaCJT81R7+czV8BmMYBM2N+aPbraUdmTh0Sjz5USDJX
      '';
      privateKeyPath = "${config.home.homeDirectory}/.ssh/thinkpad_nixos";
    };
  };
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      sendemail = {
        identity = outlook.name;
        thread = true;
        confirm = "auto";
      };
      # https://github.com/LukeChannings/dotfiles/blob/57fe7e1c188188c88092d655dbc897b3b6b54f1e/config/git/home.nix#L78
      gpg.ssh.allowedSignersFile = builtins.toString ( # package path to string
        pkgs.writeText "allowed_signers" (
          lib.concatLines (
            [ "${outlook.address} ${outlook.ssh.publicKey}" ]
          )
        )
      );
    };
    signing = {
      signByDefault = true;
      format = "ssh";
      key = outlook.ssh.privateKeyPath;
    };
    lfs.enable = true;
  };

  # GitHub CLI
  programs.gh.enable = true;
  # GitHub CLI Dashboard
  programs.gh-dash.enable = true;
}
