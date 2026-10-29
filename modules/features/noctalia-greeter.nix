{ ... }: {
  flake.nixosModules.noctaliaGreeter = { config, pkgs, lib, ... }: {
    # noctalia-greeter only reliably enables a single output unless told
    # about the rest, so multi-monitor hosts need to set these to match
    # their real layout (see noctalia-greeter's greeter.toml [output] docs:
    # layout = "CONNECTOR:X,Y; ..."; transforms = "CONNECTOR:90; ...").
    options.noctaliaGreeter = {
      outputLayout = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Raw value for greeter.toml's [output] "layout" key, e.g.
          "DP-1:0,0; DP-3:2560,0; HDMI-A-1:5120,0". Keyed by connector name
          (not make/model/serial), since that's what noctalia-greeter matches
          against.
        '';
      };
      outputTransforms = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Raw value for greeter.toml's [output] "transforms" key, e.g.
          "HDMI-A-1:270".
        '';
      };
    };

    config = {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = lib.getExe' pkgs.noctalia-greeter "noctalia-greeter-session";
          user = "greeter";
        };
      };

      systemd.tmpfiles.rules =
        [ "d /var/lib/noctalia-greeter 0750 greeter greeter - -" ]
        ++ lib.optional
          (config.noctaliaGreeter.outputLayout != null || config.noctaliaGreeter.outputTransforms != null)
          (
            let
              greeterToml = pkgs.writeText "greeter.toml" (
                "[output]\n"
                + lib.optionalString (config.noctaliaGreeter.outputLayout != null)
                  ''layout = "${config.noctaliaGreeter.outputLayout}"''
                + "\n"
                + lib.optionalString (config.noctaliaGreeter.outputTransforms != null)
                  ''transforms = "${config.noctaliaGreeter.outputTransforms}"''
                + "\n"
              );
            in
            "L+ /var/lib/noctalia-greeter/greeter.toml - - - - ${greeterToml}"
          );
    };
  };
}
