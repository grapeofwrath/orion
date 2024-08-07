{
  inputs,
  pkgs,
  host,
  gVar,
  ...
}: let
  keyName = "${gVar.username}-${host}";
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    age.keyFile = "/home/${gVar.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;
    secrets = {
      "private_keys/${keyName}" = {
        path = "/home/${gVar.username}/.ssh/id_${keyName}";
      };
    };
  };
  programs = {
    # TODO
    # make separate module for CLI only servers
    # currently only setup on grapelab
    # keychain = {
    #   enable = true;
    #   enableNushellIntegration = true;
    #   keys = [ "id_${keyName}" ];
    # };
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
  };
  services.ssh-agent.enable = true;
  # TODO
  # find a way for this to work on tty for grapelab
  systemd.user.services.add-ssh-keys = {
    Unit = {
      Description = "Add SSH keys";
      After = ["plasma-kwallet-pam.service" "sops-nix.service" "plasma-kwin_x11.service" "plasma-kwin_wayland.service" "plasma-polkit-agent.service"];
    };
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "${pkgs.openssh}/bin/ssh-add /home/${gVar.username}/.ssh/id_${keyName}";
    };
  };
}
