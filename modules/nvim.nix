{ config, pkgs, lib, ... }:

let
  # Lua configuration for Neovim
  nvimConfig = ''
    -- Set leader key
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- Basic settings
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    vim.opt.smartindent = true
    vim.opt.cursorline = true
    vim.opt.termguicolors = true
    vim.opt.signcolumn = "yes"
    vim.opt.clipboard = "unnamedplus"
    vim.opt.wrap = false

    -- Key mappings
    local keymap = vim.keymap.set
    keymap('n', '<leader>e', vim.cmd.Ex, { desc = 'Open file explorer' })
    keymap('n', '<C-d>', '<C-d>zz')
    keymap('n', '<C-u>', '<C-u>zz')
    keymap('n', 'n', 'nzzzv')
    keymap('n', 'N', 'Nzzzv')
    keymap('x', '<leader>p', '"_dP', { desc = 'Paste without overwriting register' })

    -- Lazy.nvim setup
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
      })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Plugin specifications
    require("lazy").setup({
      -- Colorscheme
      {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
          vim.cmd.colorscheme("kanagawa-wave")
        end,
      },

      -- Status line
      {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("lualine").setup({
            options = { theme = "kanagawa" },
          })
        end,
      },

      -- File explorer
      {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
          { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
        },
        config = function()
          require("nvim-tree").setup()
        end,
      },

      -- Fuzzy finder
      {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
          { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
          { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
          { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
          { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
        },
        config = function()
          require("telescope").setup({
            defaults = {
              layout_strategy = "vertical",
              layout_config = { height = 0.95 },
            },
          })
        end,
      },

      -- LSP configuration
      {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
          "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
          local lspconfig = require("lspconfig")
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          -- Setup language servers
          local servers = { "nil_ls", "tsserver", "pyright", "rust_analyzer" }
          for _, server in ipairs(servers) do
            lspconfig[server].setup({
              capabilities = capabilities,
            })
          end

          -- Keymaps for LSP
          vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
              local bufnr = args.buf
              local opts = { buffer = bufnr, remap = false }

              keymap('n', 'gd', vim.lsp.buf.definition, opts)
              keymap('n', 'K', vim.lsp.buf.hover, opts)
              keymap('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
              keymap('n', '<leader>vd', vim.diagnostic.open_float, opts)
              keymap('n', '[d', vim.diagnostic.goto_next, opts)
              keymap('n', ']d', vim.diagnostic.goto_prev, opts)
              keymap('n', '<leader>vca', vim.lsp.buf.code_action, opts)
              keymap('n', '<leader>vrr', vim.lsp.buf.references, opts)
              keymap('n', '<leader>vrn', vim.lsp.buf.rename, opts)
              keymap('i', '<C-h>', vim.lsp.buf.signature_help, opts)
            end
          })
        end,
      },

      -- Autocompletion
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-nvim-lsp",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",
        },
        config = function()
          local cmp = require("cmp")
          cmp.setup({
            snippet = {
              expand = function(args)
                require("luasnip").lsp_expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
              { name = "nvim-lsp" },
              { name = "luasnip" },
            }, {
              { name = "buffer" },
              { name = "path" },
            }),
          })
        end,
      },

      -- Treesitter (syntax highlighting)
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vim", "vimdoc", "nix", "javascript", "typescript", "python", "rust" },
            sync_install = false,
            auto_install = true,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
          })
        end,
      },

      -- Git integration
      {
        "lewis6991/gitsigns.nvim",
        config = function()
          require("gitsigns").setup()
        end,
      },

      -- Nix support
      {
        "LnL7/vim-nix",
        ft = "nix",
      },
    })
  '';
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Use Lua configuration
    extraLuaConfig = nvimConfig;

    # Plugins available in the environment
    plugins = with pkgs.vimPlugins; [
      # Lazy.nvim will handle plugin installation, but we need to make them available
      lazy-nvim
      kanagawa-nvim
      nvim-web-devicons
      lualine-nvim
      nvim-tree-lua
      telescope-nvim
      plenary-nvim
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      nvim-treesitter
      gitsigns-nvim
      vim-nix
    ];

    # Extra packages needed for Neovim functionality
    extraPackages = with pkgs; [
      # LSP servers
      nil
      typescript-language-server
      vscode-langservers-extracted
      pyright
      rust-analyzer
      
      # Formatters
      nixpkgs-fmt
      nodePackages.prettier
      rustfmt
      black
      
      # Tools
      ripgrep
      fd
      fzf
      tree-sitter
      git
    ];
  };
}
