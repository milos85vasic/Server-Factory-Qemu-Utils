#!/bin/sh

tap=$1
script_path="/tmp"
script_path_full="$script_path/server_factory_bridge_name_$tap.sh"

count=$(find "$script_path" -type f -name "$script_path/server_factory_bridge_name_*.sh" | wc -l | xargs)

if test -e "$script_path_full"; then

  bridge=$(sh "$script_path_full")
  if sudo sysctl -w net.inet.ip.forwarding=0 > /dev/null && \
    sudo sysctl -w net.link.ether.inet.proxyall=0 > /dev/null && \
    # TODO: macOS:
    # sudo sysctl -w net.inet.ip.fw.enable=1 > /dev/null && \
    sudo ifconfig "$bridge" destroy && \
    sudo rm -f "$script_path_full"; then

      echo "$bridge: Network bridge deleted"
  else

    echo "ERROR: $bridge Network bridge was not deleted"
  fi
else

  echo "No network bridge to delete"
fi

if [ "$count" = "1" ] || [ "$count" = "0"  ]; then

  qemu_scripts="qemu-ifup;qemu-ifdown;create_and_get_bridge.sh;create_bridge.sh;delete_bridge.sh;"

  export IFS=";"
  for script in $qemu_scripts; do

    script_full="/etc/$script"
    if test -e "$script_full"; then
      if sudo rm -f "$script_full"; then

        echo "$script_full: Is removed"
      else

        echo "ERROR: $script_full was not removed"
        exit 1
      fi
    fi
  done
else

  echo "Removing script is skipped, qemu instances running: $count"
fi