{ pkgs, config, ...}:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.opengl = {
  	enable = true;
	extraPackages = with pkgs; [
		vaapiVdpau
	];
  };
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.modesetting.enable = true;
}
