{ inputs, pkgs, lib, self, ... }:
let
  # installs a vim plugin from git with a given tag / branch
  # needs --impure flag 
  pluginGit = ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };

  plugin = pluginGit "HEAD";
in
{
  home.packages = [ pkgs.neovide ]
    ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [ xclip ]);
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
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
      rainbow-delimiters-nvim

      # Just an example on how to install using pluginGit
      # You have to pass the --impure flag to home-manager in order for this to work
      # (plugin "Eandrju/cellular-automaton.nvim")

      # Git
      vim-fugitive
      vim-rhubarb
      gitsigns-nvim

      # Themes
      rose-pine
      gruvbox-nvim
      # (plugin "savq/melange-nvim")
      nightfox-nvim
      kanagawa-nvim

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

      zen-mode-nvim

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

      # LSP servers
      nil
      sumneko-lua-language-server
      cmake-language-server
    ];
    # extraLuaPackages = ps: [ ps.plenary-nvim ];
  };

  xdg.configFile.nvim = {
    source = "${self}/config/nvim";
    recursive = true;
  };
}
