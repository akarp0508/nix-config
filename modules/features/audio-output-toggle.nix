{ ... }: {
  # `audio-output-toggle` switches the default PipeWire sink to the next one in
  # a list; the bar's volume widget runs it on right-click. The list is
  # per-host (node names are hardware-specific); with none set, it cycles
  # through every sink, so the module is safe to import anywhere.
  flake.nixosModules.audioOutputToggle = { config, lib, pkgs, ... }: {
    options.audio.outputToggle.sinks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "Arctis_9.*stereo-game" "pci-0000_0a_00" ];
      description = ''
        Extended regexes matched against PipeWire sink `node.name`s (see
        `wpctl status` / `pw-dump`). Each pattern is one stop in the cycle, in
        order. Empty means cycle through all sinks.
      '';
    };

    config = {
      environment.etc."audio-output-toggle".text =
        lib.concatMapStrings (p: p + "\n") config.audio.outputToggle.sinks;

      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "audio-output-toggle";
          runtimeInputs = with pkgs; [ pipewire wireplumber jq gnugrep coreutils ];
          text = ''
            # "<id> <node.name>" per sink, in PipeWire order.
            sinks=$(pw-dump | jq -r '.[] | select(.info.props["media.class"] == "Audio/Sink")
              | "\(.id) \(.info.props["node.name"])"')

            # Order the stops by the configured patterns (one match each).
            stops=""
            if [ -s /etc/audio-output-toggle ]; then
              while IFS= read -r pat; do
                [ -n "$pat" ] && stops+=$(grep -E -m1 -- "$pat" <<<"$sinks" || true)$'\n'
              done </etc/audio-output-toggle
            else
              stops="$sinks"$'\n'
            fi
            stops=$(grep -v '^$' <<<"$stops" || true)
            [ -n "$stops" ] || exit 0

            current=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep -oP 'node\.name = "\K[^"]+' || true)
            n=$(wc -l <<<"$stops")
            idx=$(awk -v c="$current" '$2 == c { print NR; exit }' <<<"$stops")
            next=$(( (''${idx:-0} % n) + 1 ))
            wpctl set-default "$(sed -n "''${next}p" <<<"$stops" | cut -d' ' -f1)"
          '';
        })
      ];
    };
  };
}
