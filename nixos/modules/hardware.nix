{config,lib,...}:
let cfg = config.orion.hardware; in {
  options.orion.hardware = {
    # TODO
    # separate bluetooth into its own module
    bluetooth = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
    };
  };
  config = {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    hardware.bluetooth = lib.mkIf cfg.bluetooth {
      enable = true;
      powerOnBoot = true;
    };
    # not sure if this is necessary, maybe just with hyprland?
    # adds secondary bluetooth systray icon on plasma
    #services.blueman.enable = mkIf cfg.bluetooth.enable true;
    networking = {inherit (cfg) hostName;};
    networking.networkmanager.enable = true;
  };
}
