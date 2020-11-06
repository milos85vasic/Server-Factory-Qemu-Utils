#!/bin/sh

tap=$1
script_path="/tmp"
script_path_full="$script_path/qemu_bridge.sh"

if test -e "$script_path_full"; then

  bridge=$(sh "$script_path_full")
  echo "$bridge"
  exit 0
else

  END=100
  for ITER in $(seq 0 $END);
  do

    bridge="bridge$ITER"
    if ! ifconfig "$bridge" >/dev/null 2>&1; then

      if sh create_bridge.sh "$bridge" "$tap" >/dev/null 2>&1; then

        echo """
        #!/bin/sh

        echo $bridge
        """ > "$script_path_full" && chmod 750 "$script_path_full"
        echo "$bridge"
        exit 0
      else

        echo "ERROR: Could not create bridge [2]"
        sh fail_and_cleanup.sh "$tap"
      fi
    fi
  done
fi

echo "ERROR: Could not obtain bridge candidate"
sh fail_and_cleanup.sh "$tap"