{ ... }:

{
  imports = [
    ./shortcut.nix
    ./config-file.nix
  ];

  programs.plasma = {
    enable = true;

    # https://github.com/pjones/plasma-manager/tree/trunk?tab=readme-ov-file#make-your-configuration-more-declarative-with-overrideconfig
    # overrideConfig = true;
  };
}
