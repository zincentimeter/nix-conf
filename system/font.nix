{ pkgs, ... }:

{
  # Font
  fonts.packages = with pkgs; [
    redhat-official-fonts
    noto-fonts-cjk
    nerdfonts
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Red Hat Mono"
      "DejaVu Sans Mono"
    ];
  };
}