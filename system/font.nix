{ pkgs, ... }:

{
  # Font

  fonts.enableDefaultPackages = true;

  fonts.packages = with pkgs; [
    redhat-official-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerdfonts
  ];

  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Red Hat Mono"
      "DejaVu Sans Mono"
      "Noto Sans Mono CJK TC"
      "Noto Sans Mono CJK SC"
    ];

    serif = [
      "DejaVu Sans"
      "Noto Serif CJK TC"
      "Noto Serif CJK SC"
    ];

    sansSerif = [
      "DejaVu Sans"
      "Noto Sans CJK TC"
      "Noto Sans CJK SC"
    ];
  };
}
