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

if_up_script="qemu-ifup"
if_up_script_full="/etc/$if_up_script"
if_up_script_backup="/etc/_$if_up_script"

if test -e "$if_up_script_backup"; then

  if test -e "$if_up_script_full"; then
    if rm -f "$if_up_script_full"; then

      echo "$if_up_script_full Is removed"
    else

      echo "ERROR: $if_up_script_full was not removed"
      exit 1
    fi
  fi

  if mv "$if_up_script_backup" "$if_up_script_full"; then

    echo "$if_up_script_backup restored to: $if_up_script_full"
  else

    echo "$if_up_script_backup was not restored to: $if_up_script_full"
    exit 1
  fi
fi