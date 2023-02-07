{ config, pkgs, lib, ...}:
let
  cfg = config.singlePciPasstrough;
  qemuHook = pkgs.writeText "${vm}-qemu"
      ''
      #!/run/current-system/sw/bin/bash
      
      GUEST_NAME="$1"
      HOOK_NAME="$2"
      STATE_NAME="$3"
      MISC="\$\{@:4}"
      
      BASEDIR="$(dirname $0)"
      
      HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"
      set -e # If a script exits with an error, we should as well.
      
      if [ -f "$HOOKPATH" ]; then
      eval \""$HOOKPATH"\" "$@"
      elif [ -d "$HOOKPATH" ]; then
      while read file; do
        eval \""$file"\" "$@"
      done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
      fi
      '';
  hooks = map (vm: {
    vmName = vm;
    modules = if cfg.gpuType == "nvidia" then "nvidia_drm nvidia_modeset nvidia_uvm nvidia" else "amdgpu";
    deviceDetach = lib.strings.concatMapStrings (device: "virst nodedev-detach pci_${device};") cfg.pciIds;
    deviceAttach = lib.strings.concatMapStrings (device: "virst nodedev-reattach pci_${device};") cfg.pciIds;
    start = pkgs.writeText "${vm}-start"
      ''
      #!/run/current-system/sw/bin/bash
      set -x
      
      # Stop display manager
      systemctl stop display-manager
          
      # Unbind VTconsoles: might not be needed
      echo 0 > /sys/class/vtconsole/vtcon0/bind
      echo 0 > /sys/class/vtconsole/vtcon1/bind
      
      # Unbind EFI Framebuffer
      echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
      
      # Unload AMD kernel module
      modprobe -r ${modules}
      
      # Detach GPU devices from host
      # Use your GPU and HDMI Audio PCI host device
      ${deviceDetach}
      
      # Load vfio module
      modprobe vfio-pci
      '';
    stop = pkgs.writeText "${vm}-stop"
      ''
      #!/run/current-system/sw/bin/bash
      set -x
      ${deviceAttach}
      modprobe -r vfio-pci
      modprobe ${modules}
      echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind
      echo 1 > /sys/class/vtconsole/vtcon0/bind
      echo 1 > /sys/class/vtconsole/vtcon1/bind
      systemctl start display-manager
      '';
  }) cfg.vmNames;
in {
  options.singlePciPassthrough = {
    enable = mkEnableOption "Single PCI Passtrough";
    cpuType = mkOption {
      default = "amd";
      type = types.str;
    };
    gpuType = mkOption {
      default = "amd";
      type = types.str;
    };
      
    pciIds = mkOption {
      description = "PCI IDs of devices to passtrought and disable on host (in order)";
      type = types.listOf types.str;
    };
    libvirtUsers = mkOption {
      description = "Users to add to libvirt group";
      type = types.listOf types.str;
      default = [];
    };
    vmNames = mkOption {
      description = "Names of vms to use single passthrough";
      type = types.listOF types.str;
    };
  }
  config = (mkIf cfg.enable {
    boot.kernelParams = [
      "pcie_acs_override=downstream"
      "${cfg.cpuType}_iommu=on"
      "kvm.ignore_msrs=1"
      "iommu=pt"
    ];
    boot.kernelModules = [ "kvm-${cfg.cpuType}" "vfio-pci"];
    environment.systemPackages = with pkgs; [
      qemu
      virtmanager
      pciutils
      OVMF
    ];
    virtualisation.libvirtd.enable = true;
    users.groups.libvirtd.members = [ "root" ] ++ cfg.libvirtUsers;
    systemd.services.libvirtd.path = [ pkgs.buildEnv {
      name = "qemu-hook-env";
      paths = with pkgs; [
        bash
        libvirt
        kmod
        systemd
        ripgrep
        sd
      ];
    }];
    copyInstructions = lib.strings.concatMapStrings (hook: ''
        mkdir -p /var/lib/libvirt/qemu.d/${hook.vmName}/{prepare/begin,/release/end};
        cp ${hook.start} /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/prepare/begin/start.sh;
        cp ${hook.stop} /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/release/end/stop.sh;
        chmod +x /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/prepare/begin/start.sh;
        chmod +x /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/release/end/stop.sh;
      '') hooks;
    systemd.services.libvirtd.preStart = ''
      mkdir -p /var/lib/libvirt/hooks;
      cp ${qemuHook} /var/lib/libvirt/hooks/qemu;
      chmod +x /var/lib/libvirt/hooks/qemu;
      ${copyInstructions}
    '';
  });
}
