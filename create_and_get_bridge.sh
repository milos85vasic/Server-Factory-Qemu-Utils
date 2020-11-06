#!/bin/sh

tap=$1
shared_Scripts_path="/tmp"
bridge_script_path="$shared_Scripts_path/qemu_bridge.sh"
scripts_path=$(sh "$shared_Scripts_path/qemu_scripts_path.sh")

if test -e "$bridge_script_path"; then

  bridge=$(sh "$bridge_script_path")
  echo "$bridge"
  exit 0
else

  END=100
  for ITER in $(seq 0 $END);
  do

    bridge="bridge$ITER"
    if ! ifconfig "$bridge" >/dev/null 2>&1; then

      if sh "$scripts_path/create_bridge.sh" "$bridge" "$tap" >/dev/null 2>&1 && \
      echo """
      #!/bin/sh

      echo $bridge
      """ | tee "$bridge_script_path" >/dev/null 2>&1 && \
      chmod 750 "$bridge_script_path"; then

        echo "$bridge"
        exit 0
      else

        echo "ERROR: Could not create bridge [2]"
        sh "$scripts_path/fail_and_cleanup.sh" "$tap"
      fi
    fi
  done
fi

echo "ERROR: Could not obtain bridge candidate"
sh "$scripts_path/fail_and_cleanup.sh" "$tap"