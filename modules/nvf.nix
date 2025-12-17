{
  programs.nvf = {
    enable = true;

    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        vimAlias = true;
        options = {
          clipboard = "unnamedplus";
          shiftwidth = 2;
          tabstop = 2;
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
        lsp = {
          enable = true;
          formatOnSave = true;
        };
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp = {
          enable = true;
          setupOpts.mapping = {
            "<Down>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
            "<Up>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
          };
          sources = {
            luasnip = "[Snippet]";
          };
        };
        languages = {
          enableTreesitter = true;
          enableFormat = true;
          rust = {
            enable = true;
            crates.enable = true; # Adds cargo crate support (like LazyVim)
          };

          zig.enable = true;

          clang = {
            enable = true; # For C and C++
            lsp.enable = true;
          };

          go.enable = true;

          bash.enable = true;

          sql.enable = true;

          # Markdown is often useful when working with these
          markdown.enable = true;
          nix.enable = true;
        };
        filetree.neo-tree.enable = true;
        ui.noice = {
          enable = true;
          setupOpts = {
            presets = {
              bottom_search = true; # keeps search bar at the bottom
              command_palette = true; # positions the command line at top-middle
              long_message_to_split = true;
            };
          };
        };
        keymaps = [
          {
            key = "<leader>e";
            mode = "n";
            action = ":Neotree toggle<CR>";
            silent = true;
            desc = "Toggle Neo-tree";
          }
          {
            key = "<leader>ff";
            mode = "n";
            action = ":Telescope find_files<CR>";
            desc = "Find Files";
          }
          {
            key = "<leader>fg";
            mode = "n";
            action = ":Telescope live_grep<CR>";
            desc = "Live Grep (Search Text)";
          }
        ];
      };
    };
  };
}
