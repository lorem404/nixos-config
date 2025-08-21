{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
    '';
    shellAliases = {
      ls = "lsd -thral";
      v = "nvim";
      c = "clear";
      fbat = "fzf -m --preview='bat --color=always {}'";
      fv = "nvim $(fzf -m --preview='bat --color=always {}')";
    };
  };
}
