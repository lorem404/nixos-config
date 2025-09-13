{ config, pkgs, lib, ... }:

let
  nvimConfig = ''
    -- Set leader key (LazyVim uses space)
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- LazyVim-like options
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.mouse = "a"
    vim.opt.showmode = false
    vim.opt.clipboard = "unnamedplus"
    vim.opt.breakindent = true
    vim.opt.undofile = true
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.signcolumn = "yes"
    vim.opt.updatetime = 250
    vim.opt.timeoutlen = 300
    vim.opt.splitright = true
    vim.opt.splitbelow = true
    vim.opt.list = true
    vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
    vim.opt.inccommand = "split"
    vim.opt.cursorline = true
    vim.opt.scrolloff = 10
    vim.opt.hlsearch = true

    -- Lazy.nvim setup (like LazyVim)
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

    -- LazyVim-like plugin specification
    require("lazy").setup({
      -- Colorscheme (LazyVim uses tokyonight)
      {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
          require("tokyonight").setup({
            style = "night",
            transparent = false,
            styles = {
              comments = { italic = true },
              keywords = { italic = true },
            },
          })
          vim.cmd.colorscheme("tokyonight")
        end,
      },

      -- LazyVim core plugins
      {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
          require("which-key").setup()
        end,
      },

      {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
          require("gitsigns").setup()
        end,
      },

      {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("lualine").setup({
            options = {
              theme = "tokyonight",
              component_separators = "|",
              section_separators = "",
            },
          })
        end,
      },

      -- File tree (LazyVim uses neo-tree)
      {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        },
        keys = {
          { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
        },
        config = function()
          require("neo-tree").setup({
            filesystem = {
              follow_current_file = true,
              hijack_netrw_behavior = "open_current",
            },
          })
        end,
      },

      -- Telescope (fuzzy finder)
      {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope-fzf-native.nvim",
        },
        keys = {
          { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
          { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
          { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
          { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        },
        config = function()
          require("telescope").setup({
            defaults = {
              layout_strategy = "vertical",
              layout_config = { height = 0.95 },
            },
          })
          require("telescope").load_extension("fzf")
        end,
      },

      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },

      -- Treesitter
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = {
              "bash", "c", "cpp", "css", "go", "html", "java", "javascript", 
              "json", "lua", "markdown", "nix", "python", "rust", "toml", 
              "typescript", "vim", "vimdoc", "yaml"
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
          })
        end,
      },

      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
      },

      -- LSP Configuration (LazyVim style)
      {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "hrsh7th/nvim-cmp",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",
        },
        config = function()
          -- Mason setup
          require("mason").setup()
          require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "nixd", "tsserver", "pyright", "rust_analyzer" },
          })

          local lspconfig = require("lspconfig")
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          -- Setup LSP servers
          local servers = { "lua_ls", "nixd", "tsserver", "pyright", "rust_analyzer" }
          for _, server in ipairs(servers) do
            lspconfig[server].setup({
              capabilities = capabilities,
            })
          end

          -- LSP keymaps (LazyVim style)
          vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
              local bufnr = args.buf
              local opts = { buffer = bufnr, remap = false }

              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
              vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
              vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
              vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
              vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
              vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
            end
          })
        end,
      },

      -- Autocompletion
      {
        "hrsh7th/nvim-cmp",
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

      -- UI enhancements
      {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
          require("ibl").setup()
        end,
      },

      {
        "numToStr/Comment.nvim",
        config = function()
          require("Comment").setup()
        end,
      },

      {
        "kylechui/nvim-surround",
        config = function()
          require("nvim-surround").setup()
        end,
      },

      -- Git
      {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gstatus", "Gblame" },
      },

      -- Nix support
      {
        "LnL7/vim-nix",
        ft = "nix",
      },
    })

    -- LazyVim-like keymaps
    local keymap = vim.keymap.set

    -- Better navigation
    keymap("n", "<C-d>", "<C-d>zz")
    keymap("n", "<C-u>", "<C-u>zz")
    keymap("n", "n", "nzzzv")
    keymap("n", "N", "Nzzzv")

    -- Quality of life
    keymap("x", "<leader>p", [["_dP]])
    keymap({ "n", "v" }, "<leader>y", [["+y]])
    keymap("n", "<leader>Y", [["+Y]])
    keymap({ "n", "v" }, "<leader>d", [["_d]])

    -- Window management
    keymap("n", "<C-h>", "<C-w>h")
    keymap("n", "<C-j>", "<C-w>j")
    keymap("n", "<C-k>", "<C-w>k")
    keymap("n", "<C-l>", "<C-w>l")

    -- Resize with arrows
    keymap("n", "<C-Up>", ":resize -2<CR>")
    keymap("n", "<C-Down>", ":resize +2<CR>")
    keymap("n", "<C-Left>", ":vertical resize -2<CR>")
    keymap("n", "<C-Right>", ":vertical resize +2<CR>")
  '';
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraLuaConfig = nvimConfig;

    plugins = with pkgs.vimPlugins; [
      # Core LazyVim-like plugins
      lazy-nvim
      tokyonight-nvim
      which-key-nvim
      gitsigns-nvim
      nvim-web-devicons
      lualine-nvim
      
      # File tree
      neo-tree-nvim
      plenary-nvim
      nui-nvim
      
      # Telescope
      telescope-nvim
      telescope-fzf-native-nvim
      
      # Treesitter
      nvim-treesitter
      nvim-treesitter-textobjects
      
      # LSP & Completion
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      
      # UI & Utilities
      indent-blankline-nvim
      comment-nvim
      nvim-surround
      vim-fugitive
      vim-nix
    ];

    extraPackages = with pkgs; [
      # LSP servers
      nil
      lua-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      pyright
      rust-analyzer
      
      # Formatters & tools
      nixpkgs-fmt
      nodePackages.prettier
      rustfmt
      black
      stylua
      
      # Telescope dependencies
      ripgrep
      fd
      fzf
      
      # Treesitter
      tree-sitter
      gcc
      nodejs
      python3
      git
    ];
  };
}
