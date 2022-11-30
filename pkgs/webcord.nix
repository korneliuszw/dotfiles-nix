{config, pkgs, ...}: let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  webcord = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/fufexan/webcord-flake/archive/master.tar.gz";
  }).defaultNix;
in {
  imports = [
    webcord.homeManagerModules.default
  ];
  programs.webcord = {
    enable = true;
      themes = let
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "discord";
      rev = "159aac939d8c18da2e184c6581f5e13896e11697";
      sha256 = "sha256-cWpog52Ft4hqGh8sMWhiLUQp/XXipOPnSTG6LwUAGGA=";
    };
  in {
    CatpuccinMocha = "${catppuccin}/themes/mocha.theme.css";
  };
  };
}
