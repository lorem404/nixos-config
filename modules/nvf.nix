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
          name = "tokyonight";
          style = "night";
        };
        lsp = {
          enable = true;
          formatOnSave = true;
          lspkind.enable = true;
          inlayHints.enable = true;
        };
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp = {
          enable = true;
          sources = {
            luasnip = "[Snippet]";
            nvim_lsp = "[LSP]";
            buffer = "[Buffer]";
            path = "[Path]";
            crates = "[Crates]";
          };
          mappings = {
            next = "<Down>";
            previous = "<Up>";
            confirm = "<CR>"; # Or "<Tab>" if you prefer
          };
        };
        languages = {
          enableLSP = true;
          enableTreesitter = true;
          enableFormat = true;
          rust = {
            enable = true;
            crates.enable = true; # Adds cargo crate support (like LazyVim)
            lsp.enable = true;
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
        tabline.nvimBufferline = {
          enable = true;
          setupOpts = {
            options = {
              # Use icons from your Nerd Font
              offsets = [
                {
                  filetype = "neo-tree";
                  text = "File Explorer";
                  text_align = "left";
                  separator = true;
                }
              ];
              # Makes it look like modern tabs
              separator_style = "thin"; # Options: "slant", "dot", "thick", "thin"
              show_buffer_close_icons = true;
              show_close_icon = false;
            };
          };
        };
        diagnostics = {
          enable = true;
          # We put the detailed settings inside 'config'
          config = {
            underline = true;
            severity_sort = true; # Now this will work!
            virtual_lines = false; # Turn this off to stop code from jumping
            virtual_text = {
              spacing = 4;
              prefix = "●";
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
          {
            key = "]b"; # Shift + l
            mode = "n";
            action = ":BufferLineCycleNext<CR>";
            desc = "Next Tab";
          }
          {
            key = "[b"; # Shift + h
            mode = "n";
            action = ":BufferLineCyclePrev<CR>";
            desc = "Previous Tab";
          }
          {
            key = "<leader>x";
            mode = "n";
            action = ":bdelete<CR>";
            desc = "Close current file";
          }
          {
            key = "[B"; # Alt + h
            mode = "n";
            action = ":BufferLineMovePrev<CR>";
            desc = "Shift Buffer Left";
          }
          # Move the current buffer/tab to the RIGHT
          {
            key = "]B"; # Alt + l
            mode = "n";
            action = ":BufferLineMoveNext<CR>";
            desc = "Shift Buffer Right";
          }
          {
            key = "<leader>|";
            mode = "n";
            action = ":vsplit<CR>";
            desc = "Split Window Vertically";
          }
          {
            key = "<C-h>"; # Ctrl + h (Left)
            mode = "n";
            action = "<C-w>h";
          }
          {
            key = "<C-j>"; # Ctrl + j (Down)
            mode = "n";
            action = "<C-w>j";
          }
          {
            key = "<C-k>"; # Ctrl + k (Up)
            mode = "n";
            action = "<C-w>k";
          }
          {
            key = "<C-l>"; # Ctrl + l (Right)
            mode = "n";
            action = "<C-w>l";
          }
        ];
      };
    };
  };
}
