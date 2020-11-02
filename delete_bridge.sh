#!/bin/sh

script_path="/usr/local/bin"
script_path_full="$script_path/server_factory_bridge_name.sh"

if test -e "$script_path_full"; then

  bridge=$(sh $script_path_full)
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

dependencies="create_and_get_bridge.sh;create_bridge.sh;create_network.sh;delete_bridge.sh;"

if_up_script="qemu-ifup"
if_down_script="qemu-ifdown"
if_up_script_full="/etc/$if_up_script"
if_down_script_full="/etc/$if_down_script"

export IFS=";"
qemu_scripts="$if_up_script_full;$if_down_script_full;$dependencies"
for script in $qemu_scripts; do

  script_backup="${script}_"
  if test -e "$script"; then
    if rm -f "$script"; then

      echo "$script: Is removed"
    else

      echo "ERROR: $script was not removed"
      exit 1
    fi
  fi

  if test -e "$script_backup"; then
    if mv "$script_backup" "$script"; then

      echo "$script_backup: restored to: $script"
    else

      echo "ERROR: $script_backup was not restored to: $script"
      exit 1
    fi
  fi
done