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
  };
}
