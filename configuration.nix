# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.default
  ];
  boot.supportedFilesystems = [ "ntfs" ];
  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  services.upower.enable = true;
  powerManagement.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = { "username" = import ./home.nix; };
  };

  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family      FiraCode Nerd Font
    bold_font        auto
    italic_font      auto
    bold_italic_font auto
    font_size        11.5
    cursor_trail     100
    background #1e1e2e  
    foreground #cdd6f4
    hide_window_decorations yes
    background_opacity 1
    shell ${pkgs.fish}/bin/fish
  '';

  programs.tmux = {
    enable = true;

    # Basic settings
    extraConfig = ''
      # Terminal and mouse settings
      set -g default-terminal "tmux-256color"
      set -g mouse on
      unbind C-b
      set -g prefix C-s
      bind s send-prefix

      # Catppuccin plugin configuration
      set -g @catppuccin_flavour "mocha"
      set -g @catppuccin_window_status_style "rounded"
      set -g @plugin 'tmux-plugins/tmux-cpu'


      # Status bar configuration
      set -g status-position top
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
      run-shell ${pkgs.tmuxPlugins.catppuccin.rtp}
    '';
  };

  programs.starship = {
    enable = true;
    # Optional: Custom settings (default: ~/.config/starship.toml)
    settings = {
      add_newline = true;
      format =
        "$directory$git_branch$git_status$cmd_duration$line_break$character";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
    '';
    shellAliases = {
      ls = "lsd -thral";
      v = "nvim";
      c = "clear";
    };
  };

  fonts.packages = with pkgs; [
    # Individual Nerd Font packages (new style)
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.roboto-mono
    font-awesome

    # Other regular fonts
    dejavu_fonts
    noto-fonts
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "FiraCode Nerd Font Mono" ];
    sansSerif = [ "Font Awesome 6 Free" ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lorem = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "lorem";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs;
      [
        #  thunderbird
      ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fish
    neovim
    fastfetch
    git
    fzf
    yazi
    ripgrep
    curl
    lazygit
    lazydocker
    bat
    tldr
    lsd
    kitty
    waybar
    wofi
    xdg-desktop-portal-gtk
    gcc
    fd
    zig
    rustup
    go
    nodejs_24
    starship
    tmux
    tmuxPlugins.catppuccin
    tmuxPlugins.cpu
    tmuxPlugins.battery
    acpi # For battery information
    lm_sensors
    htop
    btop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
