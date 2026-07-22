# Minimum Hyprland desktop sample

This directory is a complete, portable sample flake for a basic daily-use
Hyprland desktop. It deliberately leaves out the Lenovo Legion, NVIDIA PRIME,
Bluetooth, gaming, and other hardware-specific settings from
`sample_full_satup_files/`.

The profile includes:

- Hyprland launched through UWSM after TTY login
- NetworkManager and its tray applet
- PipeWire audio and `pavucontrol`
- Kitty, Fuzzel, Firefox, and Thunar
- Waybar, Mako notifications, screenshots, and clipboard tools
- Home Manager integrated into the system flake

## Rebuild an existing NixOS installation

Clone the complete repository somewhere outside `/etc/nixos`:

```bash
git clone https://github.com/PrameKung/nixos-hyprland.git ~/nixos-hyprland
```

Back up the active configuration and, most importantly, preserve the target
machine's generated hardware file:

```bash
sudo cp -a /etc/nixos /etc/nixos.before-minimum
cp /etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix
```

Copy this complete sample into `/etc/nixos`, then restore the hardware file:

```bash
sudo cp -a ~/nixos-hyprland/sample_minimum_files/. /etc/nixos/
sudo cp /tmp/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
```

Build a temporary test generation first:

```bash
sudo nixos-rebuild test --flake /etc/nixos#minimum-desktop
```

If the test succeeds, make it the active boot generation:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#minimum-desktop
```

Log in as `pramekung` on a TTY. UWSM starts Hyprland; on its first run it may
ask which desktop session should be the default.

## Fresh installation

After mounting the target system at `/mnt`, copy these files to
`/mnt/etc/nixos`, then generate the target's hardware configuration:

```bash
sudo mkdir -p /mnt/etc/nixos
sudo cp -a ~/nixos-hyprland/sample_minimum_files/. /mnt/etc/nixos/
sudo nixos-generate-config --root /mnt
sudo nixos-install --flake /mnt/etc/nixos#minimum-desktop
```

Set the normal user's password before rebooting:

```bash
sudo nixos-enter --root /mnt -c 'passwd pramekung'
```

## Values to customize

Before rebuilding for another user or location, change all matching values in
`flake.nix`, `configuration.nix`, and `home.nix`:

- `pramekung` and `/home/pramekung`
- `minimum-desktop` (flake selector and hostname)
- `Asia/Bangkok`
- `system.stateVersion` and `home.stateVersion` only when appropriate for the
  system's original NixOS/Home Manager installation version

The empty `hardware-configuration.nix` is documentation only. Never replace a
working machine's generated hardware configuration with it.
