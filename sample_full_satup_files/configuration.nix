{ pkgs, ... }:

{
  imports = [
    # Generated on the target machine during installation.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "legion";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Bangkok";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.enableRedistributableFirmware = true;

  # NVIDIA's userspace driver is unfree even when using its open kernel module.
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    # Needed by Steam, Wine, and other 32-bit applications.
    enable32Bit = true;
  };

  # The AMD iGPU remains the primary renderer. The NVIDIA GPU is available for
  # PRIME offload and for outputs physically connected to it.
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.nvidia = {
    # The GTX 1650 Ti is a Turing GPU. Try false if the open module causes a
    # hardware-specific suspend or display regression.
    open = true;
    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  # These stable device paths match the 15ARH05H profile bus IDs: AMD 06:00.0
  # first, NVIDIA 01:00.0 second. Hyprland can therefore use an external output
  # wired to NVIDIA while keeping AMD primary for the laptop desktop.
  environment.sessionVariables = {
    AQ_DRM_DEVICES = "/dev/dri/by-path/pci-0000:06:00.0-card:/dev/dri/by-path/pci-0000:01:00.0-card";
    NIXOS_OZONE_WL = "1";
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  services.upower.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.thunar.enable = true;
  programs.firefox.enable = true;

  users.users.pramekung = {
    isNormalUser = true;
    description = "PrameKung";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    pciutils
    usbutils
    mesa-demos
    vulkan-tools
    libva-utils
    brightnessctl
    playerctl
    pavucontrol
    networkmanagerapplet
    hyprpolkitagent
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";
}
