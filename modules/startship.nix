{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format =
        "$directory$git_branch$git_status$cmd_duration$line_break$character";
    };
  };
}
