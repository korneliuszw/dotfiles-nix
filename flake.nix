{
  description = "kawuka dotfiles for PC";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }: {
    nixosConfigurations.amdPc = nixpkgs.lib.nixosSystem {
      inherit (self.packages.x86_64-linux) pkgs;
      system = "x86_64-linux";
      modules = [
        ./machines/amdpc.nix
        ./configuration.nix
        ./kaw.nix
      ];
    };
    packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in {
        
      }
    );
  };
}
