{
  config,
  pkgs,
  lib,
  ...
}: 
let
# installs a vim plugin from git with a given tag / branch
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  plugin = pluginGit "HEAD";
in {
  home.packages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [xclip]);
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
      luasnip
      cmp_luasnip
      friendly-snippets

      # Treesitter and more text-objects
      (nvim-treesitter.withPlugins (p: [p.c p.cpp p.nix p.lua]))
      nvim-treesitter-textobjects
      (plugin "RRethy/nvim-treesitter-endwise")
      # pkgs.fetchFromGitHub {
      #   owner = "RRethy";
      #   name = "nvim-treesitter-endwise";
      #   rev = "master";
      # }

      # Git
      vim-fugitive
      vim-rhubarb
      gitsigns-nvim

      # Themes
      rose-pine

      # Status line
      lualine-nvim

      # Indention guides for blank lines
      indent-blankline-nvim

      # vim-commentary
      comment-nvim

      vim-surround

      nvim-autopairs

      # Detect tabstop and shiftwidth automatically
      vim-sleuth

      # Floating terminal
      toggleterm-nvim

      # Fuzzy finder
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
    ];
    extraPackages = with pkgs; [
      # LSP servers
      rnix-lsp
      sumneko-lua-language-server

      # Treesitter
      tree-sitter

      # Tools used by plugins
      ripgrep
      fd
    ];
  };

  xdg.configFile.nvim = {
    source = ../../config/nvim;
    recursive = true;
  };
}
