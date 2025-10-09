{ config, pkgs, ... }:

{
  # Enable Fish shell
  programs.fish.enable = true;

  # Rust tools package
  home.packages = with pkgs; [
    # Rust toolchain
    cargo
    rustc
    # Rust utilities
    rustfmt
    clippy
    
    # Debugging
    lldb
    gdb
    
    # Useful tools
    bacon  # Rust background compiler
    evcxr  # Rust REPL
  ];

  # Helix configuration
  programs.helix = {
    enable = true;
    
    # Default language (optional)

    settings = {
      theme = "catppuccin_mocha";
      
      editor = {
        line-number = "relative";
        cursorline = true;
        indent-guides.render = true;
        bufferline = "multiple";
        color-modes = true;
        
        # LSP settings
        lsp.display-messages = true;
        lsp.display-inlay-hints = true;
        
        # Status line
        statusline = {
          left = ["mode" "spinner" "file-name"];
          center = [];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
          separator = "│";
        };
        
        # Soft wrap
        soft-wrap.enable = true;
        
        # Auto completion
        auto-completion = true;
        idle-timeout = 150;
        
        # Auto format on save
        auto-format = true;
        auto-save = true;
      };

      keys.normal = {
        space.space = "file_picker";
        space.w = ":write";
        space.q = ":quit";
        space.f = ":format";
        space.r = ":reload";
        
        # Rust-specific bindings
        "C-c" = "code_action";
        "C-d" = ":debug-start";
        
        # LSP bindings
        "g" = {
          "d" = "goto_definition";
          "r" = "goto_reference";
          "D" = "goto_type_definition";
          "h" = "hover";
        };
        
        "K" = "hover";
      };

      keys.select = {
        "C-h" = "extend_char_left";
        "C-j" = "extend_line_down";
        "C-k" = "extend_line_up";
        "C-l" = "extend_char_right";
      };
    };

    # Languages and LSP configuration
    languages = {
      language-server = {
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          config = {
            check.command = "clippy";
            cargo.allFeatures = true;
            diagnostics.disabled = ["unresolved-proc-macro"];
            procMacro.enable = true;
            lens.enable = true;
            inlayHints = {
              enable = true;
              typeHints = true;
              parameterHints = true;
              chainingHints = true;
            };
          };
        };
      };

      language = [
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "${pkgs.rustfmt}/bin/rustfmt";
          };
          language-servers = [ "rust-analyzer" ];
          config = {
            rust-analyzer = {
              check = {
                command = "clippy";
                extraArgs = ["--" "-D" "warnings"];
              };
            };
          };
        }
        {
          name = "toml";
          auto-format = true;
          file-types = ["toml" "Cargo.toml"];
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
          };
        }
        {
          name = "markdown";
          file-types = ["md" "markdown"];
          soft-wrap.enable = true;
        }
      ];
    };

    # Themes
    themes = {
      catppuccin_mocha = {
        inherits = "catppuccin_mocha";
        "ui.background" = { };
        "ui.statusline" = { bg = "#1e1e2e"; fg = "#cdd6f4"; };
        "ui.statusline.inactive" = { bg = "#11111b"; fg = "#6c7086"; };
        "ui.cursor" = { bg = "#f5e0dc"; };
        "ui.selection" = { bg = "#585b70"; };
      };
    };
  };

  # Optional: Shell integration for Fish
  programs.fish.shellInit = ''
    # Set Helix as default editor
    set -gx EDITOR "hx"
    
    # Rust environment variables
    set -gx CARGO_HOME $HOME/.cargo
    set -gx PATH $CARGO_HOME/bin $PATH
    
    # Helix runtime for Fish completion
    if command -v hx > /dev/null
      set -gx HELIX_RUNTIME "${pkgs.helix}/runtimes"
    end
  '';
}
