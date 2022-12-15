{ ... }:
{
  imports = [
    ./pkgs/hyprland.nix
  ];
  environment.sessionVariables = rec {
  	GBM_BACKEND="nvidia-drm";
	__GL_GSYNC_ALLOWED="0";
	__GL_VRR_ALLOWED="0";
	WLR_DRM_NO_ATOMIC="1";
	__GLX_VENDOR_LIBRARY_NAME="nvidia";
	QT_QPA_PLATFORM="wayland";
	GDK_BACKEND="wayland,x11";
	WLR_NO_HARDWARE_CURSORS="1";
	MOZ_ENABLE_WAYLAND="1";
	LIBVA_DRIVER_NAME="nvidia";
	CLUTTER_BACKEND="wayland";
      };
}
