{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
      ssh-agent -c | source
      set -gx GOPATH "$HOME/.local/share/go"
      set -gx GOCACHE "$HOME/.cache/go/build"
      set -gx GOMODCACHE "$HOME/.cache/go/mod"
      set -gx PATH $PATH "$HOME/.local/share/go/bin"
    '';
    shellAliases = {
      ls = "lsd -thral";
      v = "nvim";
      c = "clear";
      fbat = "fzf -m --preview='bat --color=always {}'";
      fv = "nvim $(fzf -m --preview='bat --color=always {}')";
      t = "tmux";
    };
  };
}
