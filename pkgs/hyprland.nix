{config, pkgs, ...}: let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/refs/tags/v0.18.0beta.tar.gz";
  }).defaultNix;
in {
  imports = [
    hyprland.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.default.override {
      nvidiaPatches = true;
    };
  };
  services.greetd = {
  	enable = true;
	settings = rec {
		initial_session = {
			command = "Hyprland";
			user = "kaw";
		};
		default_session = initial_session;
	};
  };
  environment.etc."greetd/environments".text = ''
  	Hyprland
  '';
}
