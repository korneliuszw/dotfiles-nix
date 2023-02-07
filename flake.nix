{
  nixConfig.subsituters = [
    "https://cache.nixos.org"
  ];
  description = "kawuka dotfiles for PC";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    webcord.url = "github:fufexan/webcord-flake";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    spicetify-nix.url = github:the-argus/spicetify-nix;
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }@inputs:
  let
    overlays = [ self.overlays.default ];
  in {
    nixosConfigurations.amdPc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-pc-ssd
        ./machines/amdpc.nix
        ./gnome.nix
        #./plasma.nix
        #./wayland.nix
        ./configuration.nix
        { nixpkgs.overlays = [self.overlays.default]; } 
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.kaw = ./kaw.nix ;
          };
        }
      ];
    };
    nixosConfigurations.thinkpadIso = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-t480
        ./machines/thinkpad.nix
        ./gnome.nix
        #./plasma.nix
        #./wayland.nix
        ./configuration.nix
        { nixpkgs.overlays = [self.overlays.default]; } 
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.kaw = ./kaw.nix ;
          };
        }
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ];
    };
    overlays = {
      default = (final: prev: {
        unstable = import nixpkgs-unstable { system = final.system; };
      });
    };
    packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in {
        
      }
    );
  };
}
