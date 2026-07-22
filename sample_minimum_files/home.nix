{ pkgs, ... }:

{
  home.username = "pramekung";
  home.homeDirectory = "/home/pramekung";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    wl-clipboard
    grim
    slurp
  ];

  programs.git.enable = true;
  programs.kitty.enable = true;
  programs.fuzzel.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#minimum-desktop";
      rebuild-test = "sudo nixos-rebuild test --flake /etc/nixos#minimum-desktop";
    };

    # Start the desktop after this user logs in on a TTY. UWSM will prompt for
    # the default session the first time if no choice has been saved yet.
    profileExtra = ''
      if uwsm check may-start && uwsm select; then
        exec uwsm start default
      fi
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "hyprlang";
    systemd.enable = false;

    settings = {
      "$mod" = "SUPER";
      monitor = [ ", preferred, auto, 1" ];

      exec-once = [
        "nm-applet --indicator"
        "systemctl --user start hyprpolkitagent.service"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        layout = "dwindle";
      };

      decoration.rounding = 6;

      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, D, exec, fuzzel"
        "$mod, E, exec, thunar"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod SHIFT, E, exit"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "network" "pulseaudio" "tray" ];
      clock.format = "{:%a %d %b  %H:%M}";
      network.format-wifi = "{essid} {signalStrength}%";
      network.format-ethernet = "Ethernet";
      pulseaudio.format = "Vol {volume}%";
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }
      window#waybar {
        background: rgba(20, 22, 30, 0.92);
        color: #e6e9ef;
      }
      #workspaces button, #clock, #network, #pulseaudio, #tray {
        padding: 0 8px;
      }
    '';
  };

  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      default-timeout = 5000;
      border-radius = 6;
    };
  };

  gtk.enable = true;
  xdg.enable = true;
}
