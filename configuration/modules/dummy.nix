{ config, lib, pkgs, ... }:

let
  cfg = config.services.dummy;
in
{
  options.services.dummy = {
    enable = lib.mkEnableOption "dummy service";

    message = lib.mkOption {
      type = lib.types.str;
      default = "Hello from dummy module";
      description = "Message printed by the dummy module.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.hello ];

    # Create a systemd service called dummy
    systemd.services.dummy = {
      description = "Dummy service";
      wantedBy = [ "multi-user.target" ];
      # dummy service will echo the message when it starts
      serviceConfig.ExecStart =
        "${pkgs.coreutils}/bin/echo ${lib.escapeShellArg cfg.message}";
    };
  };
}
