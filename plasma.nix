{ config, pkgs, ...}:
{
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.desktopManager.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    oxygen
  ];

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };
  environment.systemPackages = with pkgs; [
    kcalc
    okular
    ark
    unstable.latte-dock
  ];
}
