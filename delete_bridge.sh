#!/bin/sh

tap=$1
script_path="/tmp"
script_path_full="$script_path/server_factory_bridge_name_$tap.sh"

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

export IFS=";"
qemu_scripts="qemu-ifup;qemu-ifdown;create_and_get_bridge.sh;create_bridge.sh;delete_bridge.sh;"
for script in $qemu_scripts; do

  script_full="/etc/$script"
  script_backup="${script_full}_"

  if test -e "$script_full"; then
    if sudo rm -f "$script_full"; then

      echo "$script_full: Is removed"
    else

      echo "ERROR: $script_full was not removed"
      exit 1
    fi
  fi

  if test -e "$script_backup"; then
    if sudo mv "$script_backup" "$script_full"; then

      echo "$script_backup: restored to: $script_full"
    else

      echo "ERROR: $script_backup was not restored to: $script_full"
      exit 1
    fi
  fi
done