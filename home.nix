{ config, pkgs, ... }:

{
  imports = [
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/hyprland.nix
    ./modules/startship.nix
    ./modules/waybar.nix
    ./modules/tmux.nix
    ./modules/kitty.nix
  ];

  home.username = "lorem";
  home.homeDirectory = "/home/lorem";
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # In your home.nix instead
  home.sessionVariables = {
    # Force rootless mode through environment
    PODMAN_USERNS = "auto";
  };

  programs.bash.shellAliases = {
    # Clear distinction between docker and podman
    dps = "docker ps";
    pps = "podman ps";

    # Podman learning shortcuts
    plearn = "podman run --rm -it docker.io/library/alpine:latest";
    pbuild = "buildah bud";
    ppush = "skopeo copy";
  };

  # Required packages for the default config to work

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    pamixer
    brightnessctl
    pulseaudio
    podman-tui # Terminal UI for Podman
    nodejs_24
    # Development tools
    docker-credential-helpers
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
