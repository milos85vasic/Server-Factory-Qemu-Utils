#!/bin/sh

tap=$1
script_path="/tmp"
bridge_script_path="$script_path/qemu_bridge.sh"
scripts_path=$(sh "$script_path/qemu_scripts_path.sh")
log=$(sh "$scripts_path/get_machine_log_name.sh" "$tap")
count=$(sh "$scripts_path/get_running_machines_count.sh")

if [ "$count" = "0"  ]; then

  echo "No running qemu machines detected"
else

  echo "Running qemu machines detected: $count"
fi

if sudo test -e "$log"; then
  if sudo rm -f "$log"; then

    echo "Log removed: $log"
  else

    echo "WARNING: Log not removed: $log"
  fi
fi

if [ "$count" = "1" ] || [ "$count" = "0"  ]; then

  if test -e "$bridge_script_path"; then

    bridge=$(sh "$bridge_script_path")
    if sudo sysctl -w net.inet.ip.forwarding=0 >/dev/null 2>&1 && \
      sudo sysctl -w net.link.ether.inet.proxyall=0 >/dev/null 2>&1 && \
      if ! sh "$scripts_path/is_macos.sh"; then sudo sysctl -w net.inet.ip.fw.enable=1 >/dev/null 2>&1; fi && \
      sudo ifconfig "$bridge" destroy && \
      sudo rm -f "$bridge_script_path"; then

        echo "$bridge: Network bridge deleted"
    else

      echo "ERROR: $bridge Network bridge was not deleted"
    fi
  else

    echo "No network bridge to delete"
  fi


  sh "$scripts_path/delete_dependencies.sh" "$tap"
else

  echo "Removing scripts is skipped, qemu instances still running"
fi