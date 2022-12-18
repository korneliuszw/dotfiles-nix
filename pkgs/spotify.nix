{ pkgs, lib, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  # import the flake's module for your system
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  # configure spicetify :)
  programs.spicetify =
    {
      enable = true;
      theme = spicePkgs.themes.catppuccin-macchiato;
      colorScheme = "flamingo";

      enabledExtensions = with spicePkgs.extensions; [
        "fullAppDisplay.js"
        "shuffle+.js"
        "genre.js"
      ];
  };
}
