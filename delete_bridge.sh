#!/bin/sh

tap=$1
log=$(sh get_machine_log_name.sh "$tap")

count=$(sh get_running_machines_count.sh)
echo "Running qemu machines detected: $count"

script_path="/tmp"
script_path_full="$script_path/server_factory_bridge.sh"

if sudo test -e "$log"; then
  if sudo rm -f "$log"; then

    echo "Log removed: $log"
  else

    echo "WARNING: Log not removed: $log"
  fi
fi

if [ "$count" = "1" ] || [ "$count" = "0"  ]; then

  if test -e "$script_path_full"; then

    bridge=$(sh "$script_path_full")
    if sudo sysctl -w net.inet.ip.forwarding=0 >/dev/null 2>&1 && \
      sudo sysctl -w net.link.ether.inet.proxyall=0 >/dev/null 2>&1 && \
      # TODO: macOS:
      # sudo sysctl -w net.inet.ip.fw.enable=1 >/dev/null 2>&1 \
      sudo ifconfig "$bridge" destroy && \
      sudo rm -f "$script_path_full"; then

        echo "$bridge: Network bridge deleted"
    else

      echo "ERROR: $bridge Network bridge was not deleted"
    fi
  else

    echo "No network bridge to delete"
  fi

  qemu_scripts=$(sh get_dependencies.sh)

  export IFS=";"
  for script in $qemu_scripts; do

    script_full="/etc/$script"
    if test -e "$script_full"; then
      if sudo rm -f "$script_full"; then

        echo "$script_full: Is removed"
      else

        echo "ERROR: $script_full was not removed"
        sh fail_and_cleanup.sh "$tap"
      fi
    fi
  done
else

  echo "Removing script is skipped, qemu instances still running"
fi