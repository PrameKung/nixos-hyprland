# configuration.nix
{ config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "legion";
    networking.networkmanager.enable = true;

    time.timeZone = "Asia/Bangkok";

    programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
    };

    users.users.pramekung = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [
            tree
        ];
    };

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        wget
        kitty
        hyprpaper
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    system.stateVersion = "26.05";
}
