{config, pkgs, inputs, ...}:
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default.override {
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
