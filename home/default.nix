{ config, lib, ... }:

{
  # Program configured with home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.shinri = {
      # Home Manager needs a bit of information about you and the
      # paths it should manage.
      home.username = config.users.users.shinri.name;
      home.homeDirectory = config.users.users.shinri.home;

      imports = [
        ./vscode.nix
        ./onedrive.nix
      ] ++ lib.optional (builtins.pathExists ./ssh.nix) ./ssh.nix;

      # This value determines the home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update home Manager without changing this value. See
      # the home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "23.11";
    };
  };
}