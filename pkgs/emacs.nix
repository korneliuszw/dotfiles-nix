{ pkgs, inputs, ... }:
{
  programs.doom-emacs = {
    doomPrivateDir = ./doom.d;
    enable = true;
  };
}
