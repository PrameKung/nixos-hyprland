{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # This sample expects an x86-64 UEFI machine with its EFI partition mounted
  # at /boot. Change the boot loader if the target machine uses another setup.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "minimum-desktop";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Bangkok";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  hardware.graphics.enable = true;

  # Audio support for native ALSA applications and PulseAudio clients.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # File-manager integration for removable media, trash, and thumbnails.
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.thunar.enable = true;
  programs.firefox.enable = true;

  # Needed by graphical applications that request administrator privileges.
  security.polkit.enable = true;

  users.users.pramekung = {
    isNormalUser = true;
    description = "PrameKung";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    networkmanagerapplet
    hyprpolkitagent
    pavucontrol
    brightnessctl
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Keep this at the release used for the first installation of this profile.
  system.stateVersion = "26.05";
}
