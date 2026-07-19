{ config, pkgs, ... }:

{
    home.username = "pramekung";
    home.homeDirectory = "/home/pramekung";
    home.stateVersion = "26.05";
    programs.git.enable = true;
    programs.bash = {
        enable = true;
        shellAliases = {
            btw = "echo i use nixos, btw";
        };
        profileExtra = ''
          if uwsm check may-start && uwsm select; then
            exec uwsm start default
          fi
        '';
    };
}
