{ config, ... }:

{
  options = {
  };

  imports = [
    # system-related persist
    ./system.nix
    # user-related persist
    ./user.nix
  ];
}
