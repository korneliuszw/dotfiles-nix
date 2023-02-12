{ config, pkgs, lib, ...}:
let
  cfg = config.singlePciPassthrough;
  qemuHook = pkgs.writeText "qemu"
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
    hooks = map (vm:
      let
        modules = if cfg.gpuType == "nvidia" then "nvidia_drm nvidia_modeset nvidia_uvm nvidia" else "drm_kms_helper amdgpu ttm drm";
        deviceDetach = lib.strings.concatMapStrings (device: "virsh nodedev-detach pci_${device};") cfg.pciIds;
        deviceAttach = lib.strings.concatMapStrings (device: "virsh nodedev-reattach pci_${device};") cfg.pciIds;
      in {
        vmName = vm;
        start = pkgs.writeText "${vm}-start"
          ''
          #!/run/current-system/sw/bin/bash
          set -x
          
          # Stop display manager
          systemctl stop display-manager
          systemctl isolate multi-user.target
          pkill gdm-x-session
          if test -e "/tmp/vfio-bound-consoles"; then
            rm -f /tmp/vfio-bound-consoles
          fi
          for (( i = 0; i < 16; i++))
            do
              if test -x /sys/class/vtconsole/vtcon$i; then
                  if [ "$(grep -c "frame buffer" /sys/class/vtconsole/vtcon$i/name)" = 1 ]; then
                    echo 0 > /sys/class/vtconsole/vtcon$i/bind
                    echo "$i" >> /tmp/vfio-bound-consoles
                  fi
              fi
            done

          # Unbind EFI Framebuffer
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
          ${deviceDetach}
          # Unload AMD kernel module
          modprobe -r amdgpu
          modprobe -r ttm
          modprobe -r drm_kms_helper
          modprobe -r drm
          #modprobe -r amdgpu ttm
          #modprobe -r drm_kms_helper drm
          #modprobe -r ${modules}         
          #modprobe -r ${modules}         
          # Detach GPU devices from host
          # Use your GPU and HDMI Audio PCI host device
          
          # Load vfio module
          modprobe vfio
          modprobe vfio_pci
          modprobe vfio_iommu_type1
          '';
        stop = pkgs.writeText "${vm}-stop"
          ''
          #!/run/current-system/sw/bin/bash
          set -x
          ${deviceAttach}
          modprobe -r vfio
          modprobe -r vfio_pci
          modprobe -r vfio_iommu_type1
          modprobe -a ${modules}
          echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind
          echo 1 > /sys/class/vtconsole/vtcon0/bind
          echo 1 > /sys/class/vtconsole/vtcon1/bind
          systemctl start display-manager
          input="/tmp/vfio-bound-consoles"
          while read -r consoleNumber; do
            if test -x /sys/class/vtconsole/vtcon$consoleNumber; then
                if [ "$(grep -c "frame buffer" /sys/class/vtconsole/vtcon$consoleNumber/name)" \
                     = 1 ]; then
          	  echo 1 > /sys/class/vtconsole/vtcon$consoleNumber/bind
                fi
            fi
          done < "$input"

          '';
  }) cfg.vmNames;
  copyInstructions = lib.strings.concatMapStrings (hook: ''
      mkdir -p /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/prepare/begin;
      mkdir -p /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/release/end;
      cp ${hook.start} /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/prepare/begin/start.sh;
      cp ${hook.stop} /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/release/end/stop.sh;
      chmod +x /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/prepare/begin/start.sh;
      chmod +x /var/lib/libvirt/hooks/qemu.d/${hook.vmName}/release/end/stop.sh;
    '') hooks;
  ovfmFull = pkgs.OVMFFull.override {
    secureBoot = true;
    tpmSupport = true;
  };
  quickemuNew = pkgs.quickemu.overrideAttrs (old: {
    version = "4.6";
    src = pkgs.fetchFromGitHub {
      owner = "quickemu-project";
      repo = "quickemu";
      rev = "4.6";
      hash = "sha256-C/3zyHnxAxCu8rrR4Znka47pVPp0vvaVGyd4TVQG3qg=";
    };
  });
in {
  options.singlePciPassthrough = {
    enable = lib.mkEnableOption "Single PCI Passtrough";
    cpuType = lib.mkOption {
      default = "amd";
      type = lib.types.str;
    };
    gpuType = lib.mkOption {
      default = "amd";
      type = lib.types.str;
    };
      
    pciIds = lib.mkOption {
      description = "PCI IDs of devices to passtrought and disable on host (in order)";
      type = lib.types.listOf lib.types.str;
    };
    libvirtUsers = lib.mkOption {
      description = "Users to add to libvirt group";
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    vmNames = lib.mkOption {
      description = "Names of vms to use single passthrough";
      type = lib.types.listOf lib.types.str;
    };
  };
  config = lib.mkIf cfg.enable {
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
      swtpm
      quickemuNew
    ];
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.swtpm.package = pkgs.qemu_kvm;
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    virtualisation.libvirtd.qemu.ovmf = {
      enable = true;
      packages = [ovfmFull.fd];
    };
    users.groups.libvirtd.members = [ "root" ] ++ cfg.libvirtUsers;
    systemd.services.libvirtd.path = [ (pkgs.buildEnv {
      name = "qemu-hook-env";
      paths = with pkgs; [
        bash
        libvirt
        kmod
        systemd
        ripgrep
        sd
      ];
    })];
    systemd.services.libvirtd.preStart = ''
      mkdir -p /var/lib/libvirt/hooks;
      cp ${qemuHook} /var/lib/libvirt/hooks/qemu;
      chmod +x /var/lib/libvirt/hooks/qemu;
      ${copyInstructions}
    '';
    environment.sessionVariables = {
      ENV_EFI_VARS_SECURE="/run/libvirt/nix-ovmf/OVMF_VARS.fd";
      ENV_EFI_CODE_SECURE="/run/libvirt/nix-ovmf/OVMF_CODE.fd";
    };
  };
}
