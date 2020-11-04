#!/bin/sh

script_path="/tmp"
script_path_full="$script_path/server_factory_bridge.sh"

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

      if sh create_bridge.sh "$bridge" > /dev/null; then

        echo """
        #!/bin/sh

        echo $bridge
        """ > "$script_path_full" && chmod 750 "$script_path_full"
        echo "$bridge"
        exit 0
      else

        echo "ERROR: Could not create bridge [2]"
        exit 1
      fi
    fi
  done
fi

echo "ERROR: Could not obtain bridge candidate"
exit 1