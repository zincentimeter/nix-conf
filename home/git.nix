{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    extraConfig = {
      sendemail = {
        identity = "outlook";
        thread = true;
        confirm = "auto";
      };
    };
    lfs.enable = true;
  };

  # GitHub CLI
  programs.gh.enable = true;
  # GitHub CLI Dashboard
  programs.gh-dash.enable = true;
}
