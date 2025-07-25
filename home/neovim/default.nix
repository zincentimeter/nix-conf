{ pkgs, ... }:

/*
  TODO list on neovim:
  - [ ] neo-tree sometimes does not auto close when it is the last one
  - [x] :terminal open terminal on the current window, but want it to open in a new split window
    - Solved: created a keymap to open new terminal in split window
  - [x] split won't focus on the newly-spawn window
    - Solved: split will always focus on newly created window,
      but split is default to split to left/up, causing an illusion
  - [ ] nvr to stop recursive vim window on `sudo -i` and `git commit` and other pagers.
  - [ ] paste contents from visual selection into Telescope's line buffer
*/
{

  home.packages = with pkgs; [
    # Language Server for Nix, Lua and Typst
    nil
    lua-language-server
    # an integrated language service for Typst
    tinymist
    # Extremely fast Python linter and code formatter
    pyright
    # dependency of typst-preview-nvim
    websocat

    # Styler
    typstyle

    # Dev Tools for C/C++
    clang-tools

    # required by `Telescope live_grep`
    ripgrep

    # Opening files from within :terminal without starting a nested nvim process
    neovim-remote
  ];
  
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    # must be enabled with shell configuration in home-manager 
    defaultEditor = true;
    
    extraLuaConfig = builtins.readFile ./neovim-init.lua;

    plugins = with pkgs.vimPlugins; [
      # base plugin libraries
      plenary-nvim

      # language server protocol
      nvim-lspconfig
	
      # Tree-sitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects

      # git
      neogit
      vim-fugitive
      gitsigns-nvim
 
      # UI
      dropbar-nvim # breadcrumbs hierarchy lists
      noice-nvim # overall beautify
      lualine-nvim # status line
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
      cmp-vimtex

      # shortcuts & keys
      which-key-nvim

      # file explorer
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

      # extra functionalities
      # preview images
      image-nvim
      # preview tables in nvim
      csvview-nvim
    ];
  };

  # use nvim as the manpager to view linux manual
  home.sessionVariables.MANPAGER = "nvim +Man!";
}
