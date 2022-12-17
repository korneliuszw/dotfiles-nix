{ config, pkgs, lib, ...}:
{

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

  services.mpd.enable = true;
}
