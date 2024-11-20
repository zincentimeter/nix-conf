{ pkgs, ... }:

{
  # User-related information

  users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    hashedPassword = "REDACTED=================================================================";
  };
  users.users.shinri = {
    description = "Shinri Kosame";
    hashedPassword = "REDACTED=================================================================";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # Adopted for all users
  # here, only basic level configure and utilities will be adopted.
  # configure the neovim to be the defaultEditor.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  # Shell
  environment.systemPackages = with pkgs; [
    # Shell (mainly for `fish`) plugins
    # A utility tool powered by fzf for using git interactively.
    fishPlugins.forgit
    # A command-line fuzzy finder written in Go
    fzf
  ];
  programs.fish.enable = true;
  # default shell for all users, including root
  users.defaultUserShell = pkgs.fish;
}
