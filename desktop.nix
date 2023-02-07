{ config, pkgs, lib, ...}:
let
  sf = pkgs.callPackage ./pkgs/font-sf.nix {};
  sf-mono = pkgs.callPackage ./pkgs/font-sf-mono.nix {};
in {
  programs.dconf.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    proggyfonts
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" ];
    })
    sf
    sf-mono
  ];
  sound.enable = true;
  services.xserver.layout = "pl";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;
}
