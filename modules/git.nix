{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      # Use 'alias' instead of 'aliases'
      alias = {
        lg = "log --color --graph";
      };
      user = {
        name = "lorem";
        email = "lorem8023@gmail.com";
      };
      # Move everything from extraConfig here
      core = {
        editor = "nvim";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
