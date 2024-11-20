{ pkgs, ... }:

{
  home.packages = with pkgs; [
    typst
  ];
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs)
        scheme-full
        collection-basic
        collection-latex
        collection-fontsrecommended
        latexmk
        # URW-base35, Times New Roman
        times
      ;
    };
  };
}
