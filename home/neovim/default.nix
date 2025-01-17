{ pkgs, ... }:

{

  home.packages = with pkgs; [
    # Language Server for Nix, Lua and Typst
    nil
    lua-language-server
    # an integrated language service for Typst
    tinymist
    # dependency of typst-preview-nvim
    websocat

    # Styler
    typstyle

    # Dev Tools for C/C++
    clang-tools

    # required by `Telescope live_grep`
    ripgrep
  ];
  
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    # must be enabled with shell configuration in home-manager 
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

      # shortcuts & keys
      which-key-nvim

      # file explorer
      oil-nvim
      neo-tree-nvim
      telescope-nvim

      # lang
      luasnip
      pkgs.stra.vimPlugins.typst-preview-nvim
      markdown-preview-nvim
      lazydev-nvim
      clangd_extensions-nvim
      vimtex
      # https://discourse.nixos.org/t/help-using-a-nixpkgs-overlay-in-a-flake/46075/2
      pkgs.stra.vimPlugins.luvit-meta
    ];
  };
  

}
