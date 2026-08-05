{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nvf.url = "github:notashelf/nvf";
    hyprland.url = "github:hyprwm/hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    # nixpkgs-stable,
    hyprland,
    ...
  } @ inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.vivobook = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        nvf.nixosModules.default
        inputs.hyprland.nixosModules.default
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
