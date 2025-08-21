{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "lorem";
    userEmail = "lorem8023@gmail.com";

    aliases = { lg = "log --color --graph "; };

    extraConfig = { core.editor = "nvim"; };
  };
}
