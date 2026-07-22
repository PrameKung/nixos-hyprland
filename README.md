# NixOS Hyprland configuration

Personal NixOS 26.05 configuration for an x86-64 UEFI machine using Hyprland, UWSM, and Home Manager.

## System identity

| Setting | Value |
| --- | --- |
| Username | `pramekung` |
| Home directory | `/home/pramekung` |
| Hostname | `legion` |
| Flake selector | `pramekung_legion` |
| Time zone | `Asia/Bangkok` |
| Architecture | `x86_64-linux` |

The flake selector is the name used after `#` in Nix commands. It does not need to match the hostname.

## Repository layout

- `flake.nix` selects NixOS 26.05, Home Manager 26.05, and the `pramekung_legion` system.
- `configuration.nix` contains system-wide configuration.
- `home.nix` contains the Home Manager configuration for `pramekung`.
- `hardware-configuration.nix` is intentionally empty in Git. Generate it on the target computer during installation.
- `sample_files/` contains reference material only and is not imported by the active configuration.
- `sample_minimum_files/` is a complete, portable minimum Hyprland desktop flake that can be copied to `/etc/nixos` for a rebuild.
- `sample_full_satup_files/` is the complete Lenovo Legion/NVIDIA-specific desktop example.

## Before installation

This repository is prepared on Windows, so it is reviewed statically there. Nix evaluation and the real hardware check happen from the NixOS installation environment after the target filesystems are mounted.

The current configuration assumes:

- A 64-bit Intel or AMD computer.
- UEFI boot, with the EFI System Partition mounted at `/mnt/boot`.
- The target root filesystem mounted at `/mnt`.
- A working internet connection.

Partitioning and formatting are machine-specific and destructive, so they are intentionally not scripted here. Follow the [official NixOS installation guide](https://nixos.org/manual/nixos/stable/#sec-installation) and confirm all device names before formatting anything.

## Installation

After partitioning, formatting, and mounting the target root and EFI filesystems, become root:

```bash
sudo -i
```

Configure networking if necessary. The installer provides NetworkManager and its text interface:

```bash
nmtui
```

Clone this repository into the future system:

```bash
mkdir -p /mnt/etc
git clone https://github.com/PrameKung/nixos-hyprland.git /mnt/etc/nixos
```

If `git` is unavailable in the installer, run it temporarily through Nix:

```bash
nix --extra-experimental-features "nix-command flakes" shell nixpkgs#git -c \
  git clone https://github.com/PrameKung/nixos-hyprland.git /mnt/etc/nixos
```

Generate the target computer's hardware configuration. This replaces the intentionally empty tracked file:

```bash
nixos-generate-config --root /mnt
```

Confirm that it is no longer empty and inspect the detected filesystems before continuing:

```bash
test -s /mnt/etc/nixos/hardware-configuration.nix
sed -n '1,240p' /mnt/etc/nixos/hardware-configuration.nix
```

Also confirm that the prepared identity values are present:

```bash
grep -R -nE 'pramekung_legion|hostName|home\.username|home\.homeDirectory|users\.pramekung|users\.users\.pramekung' \
  /mnt/etc/nixos/{flake.nix,configuration.nix,home.nix}
```

### Preflight build

Evaluate and build the complete system before installing it. This catches Nix syntax, module, username, option, and package errors without modifying the running installer system:

```bash
nix --extra-experimental-features "nix-command flakes" build \
  '/mnt/etc/nixos#nixosConfigurations.pramekung_legion.config.system.build.toplevel' \
  --no-link
```

The first flake command resolves the inputs and creates `flake.lock`. Keep that file after installation for reproducible future rebuilds.

If the preflight build succeeds, install the prepared configuration:

```bash
nixos-install --flake /mnt/etc/nixos#pramekung_legion
```

Set a password for the normal user before rebooting:

```bash
nixos-enter --root /mnt -c 'passwd pramekung'
```

Then reboot:

```bash
reboot
```

## First login

There is no graphical display manager in this configuration. Log in as `pramekung` on TTY1. The Bash profile uses UWSM to select and start the Hyprland session. Choose Hyprland when prompted.

## Rebuilding after installation

After editing files under `/etc/nixos`, apply the `pramekung_legion` configuration with:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#pramekung_legion
```

For a safer trial that does not make the new generation the boot default:

```bash
sudo nixos-rebuild test --flake /etc/nixos#pramekung_legion
```

## Important notes

- Do not use UUIDs from `sample_files/hardware-configuration.sample.nix`.
- Do not run the flake build before generating `hardware-configuration.nix` on the target machine.
- Keep `system.stateVersion` and `home.stateVersion` at `26.05` for this fresh installation.
- The active username is `pramekung`; `tony` and the sample usernames must not appear in active configuration files.
- The hostname is `legion`; `pramekung_legion` is only the flake selector.
- Hyprland is started from TTY1 through UWSM rather than through a display manager.

## References

- [NixOS 26.05 installation manual](https://nixos.org/manual/nixos/stable/#sec-installation)
- [Hyprland on NixOS](https://wiki.hypr.land/Nix/Hyprland-on-NixOS/)
