{config, pkgs, ... }:
{
  programs.neovim = {
    package = pkgs.unstable.neovim-unwrapped;
    #coc.package = pkgs.unstable.vimPlugins.coc-nvim;
    enable = true;
    withPython3 = true;
    withNodeJs = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      catppuccin-nvim
      {
        plugin = nvim-comment;
        type = "lua";
        config = builtins.readFile(./nvim/comment.lua);
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = builtins.readFile(./nvim/tree.lua);
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile(./nvim/line.lua);
      }
      nvim-lspconfig
      pkgs.unstable.vimPlugins.nvim-cmp
      {
        plugin = pkgs.unstable.vimPlugins.nvim-cmp;
        type = "lua";
        config = builtins.readFile(./nvim/cmp.lua);
      }
      pkgs.unstable.vimPlugins.cmp-nvim-lsp
      pkgs.unstable.vimPlugins.ultisnips
      pkgs.unstable.vimPlugins.yuck-vim
      pkgs.unstable.vimPlugins.cmp-nvim-ultisnips
      pkgs.unstable.vimPlugins.cmp-path
      pkgs.unstable.vimPlugins.cmp-buffer
      pkgs.unstable.vimPlugins.cmp-nvim-tags
    ];
    #coc.enable = true;
    extraConfig = ''
      colorscheme catppuccin
      set nocompatible
      set tabstop=2 shiftwidth=2 expandtab
      " Show tabs and trailing whitespace.
      set list listchars=tab:>\ 
      " Don't insert two spaces after '.', '?', and '!' with a join.
      set nojoinspaces
      set nowrap linebreak
      set wildmenu wildignorecase
      set ignorecase
      set undofile
      set clipboard+=unnamedplus " Not sure 
      set number relativenumber
      set history=200
      filetype indent plugin on
      syntax on
      let mapleader=' '
      let maplocalleader=' '
      lua require('init')
    '';

  };
    xdg.configFile.nvim = {
      source = ./nvim/configuration;
      recursive = true;
    };
}
