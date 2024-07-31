{ pkgs, ... }:

let
  luvit-meta = pkgs.vimUtils.buildVimPlugin {
    pname = "luvit-meta";
    src = pkgs.fetchFromGitHub {
      owner = "Bilal2453";
      repo = "luvit-meta";
      rev = "ce76f6f6cdc9201523a5875a4471dcfe0186eb60";
      hash = "sha256-zAAptV/oLuLAAsa2zSB/6fxlElk4+jNZd/cPr9oxFig=";
    };
    version = "2024-07-30";
  };
in
{

  home.packages = with pkgs; [
    # Language Server for Nix and Lua
    nixd
    lua-language-server

    # Dev Tools for C/C++
    clang-tools
  ];
  
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
    
    extraConfig = ''
      set number relativenumber
      colorscheme edge
      set termguicolors
    '';

    extraLuaConfig = builtins.readFile ./neovim-init.lua;
    plugins = with pkgs.vimPlugins; [
      # base plugin libraries
      plenary-nvim

      # language server protocol
      nvim-lspconfig
	
      # Tree-sitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-context

      # git
      neogit
 
      # UI
      noice-nvim # overall beautify
      feline-nvim # status line
      edge # color theme
      trouble-nvim # show errors

      # auto-complete
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-cmdline
      cmp-calc
      cmp_luasnip

      # file explorer
      oil-nvim
      neo-tree-nvim
      telescope-nvim

      # lang
      luasnip
      markdown-preview-nvim
      lazydev-nvim
      clangd_extensions-nvim
    ] ++ [
      luvit-meta
    ];
  };
  

}
