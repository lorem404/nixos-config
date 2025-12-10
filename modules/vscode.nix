# home.nix
{ config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    
    # Choose your version
    package = pkgs.vscode;  # Open Source version
    # package = pkgs.vscode-fhs;  # FHS version (better compatibility)
    # package = pkgs.vscodium;    # VS Codium (no telemetry)
    
    extensions = with pkgs.vscode-extensions; [
      # Essential extensions
      jnoortheen.nix-ide          # Nix language support
      bbenoist.nix                # Nix syntax highlighting
      arrterian.nix-env-selector  # Nix environment selector
      
      # Language support
      rust-lang.rust-analyzer
      ms-python.python
      golang.go
      
      # UI/Productivity
      eamodio.gitlens
      vscodevim.vim
      esbenp.prettier-vscode
      
    ];
  };
}
