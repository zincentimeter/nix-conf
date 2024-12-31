{ pkgs, ... }:

{
  # Font

  fonts.enableDefaultPackages = true;

  fonts.packages = with pkgs; [
    redhat-official-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    sf-pro
    sf-compact
    sf-mono
    ny
  ] ++ builtins.filter lib.attrsets.isDerivation (
    builtins.attrValues pkgs.nerd-fonts
  );

  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Red Hat Mono"
      "DejaVu Sans Mono"
      "Noto Sans Mono CJK TC"
      "Noto Sans Mono CJK SC"
    ];

    serif = [
      "New York Medium"
      "DejaVu Sans"
      "Noto Serif CJK TC"
      "Noto Serif CJK SC"
    ];

    sansSerif = [
      "SFPro Text"
      "DejaVu Sans"
      "Noto Sans CJK TC"
      "Noto Sans CJK SC"
    ];
  };
}
