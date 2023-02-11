{ config, pkgs, lib, ... }:
let
  # installs a vim plugin from git with a given tag / branch
  # Needs --impure flag 
  pluginGit = ref: repo:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };

  plugin = pluginGit "HEAD";
  lang = config.languages;
in {
  home.packages = [ pkgs.neovide ]
    ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [ xclip ]);
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # LSP and plugins
      nvim-lspconfig
      neodev-nvim
      fidget-nvim

      # Autocompletion
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      luasnip
      cmp_luasnip

      # Snippet collections
      friendly-snippets
      vim-snippets

      # Treesitter and plugins
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.c
        p.cpp
        p.cmake
        p.python
        p.lua
        p.latex
        p.haskell
        p.rust
      ]))
      nvim-treesitter-textobjects
      nvim-ts-rainbow

      # Just an example on how to install using pluginGit
      # You have to pass the --impure flag to home-manager in order for this to work
      (plugin "Eandrju/cellular-automaton.nvim")

      # Git
      vim-fugitive
      vim-rhubarb
      gitsigns-nvim

      # Themes
      rose-pine
      gruvbox-nvim
      (plugin "savq/melange-nvim")
      nightfox-nvim

      # Status line
      lualine-nvim

      # Indention guides for blank lines
      indent-blankline-nvim

      # Neccessary plugins
      comment-nvim
      vim-surround
      nvim-autopairs

      # Leap?
      leap-nvim

      # Detect tabstop and shiftwidth automatically
      vim-sleuth

      # Floating terminal
      toggleterm-nvim

      # Telescope and plugins
      plenary-nvim
      telescope-nvim
      nvim-web-devicons
      telescope-fzf-native-nvim

      # Plugins with telescope extensions
      project-nvim
      telescope-zoxide

      markdown-preview-nvim
      (plugin "ekickx/clipboard-image.nvim")

      vimtex
    ];
    extraPackages = with pkgs; [
      # Treesitter
      tree-sitter

      # Tools used by telescope
      ripgrep
      bat
      fd
      fzf
    ];
    # extraLuaPackages = ps: [ ps.plenary-nvim ];
  };

  xdg.configFile.nvim = {
    source = ../../config/nvim;
    recursive = true;
  };
}
