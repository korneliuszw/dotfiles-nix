{pkgs, ...}:
{
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
}
