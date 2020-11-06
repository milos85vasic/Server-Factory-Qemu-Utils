#!/bin/sh

tap=$2
bridgeName=$1
scripts_path=$(sh "/tmp/qemu_scripts_path.sh")

if ! ifconfig "$bridgeName" >/dev/null 2>&1; then

  echo "$bridgeName: Creating network bridge"
  if sudo sysctl -w net.link.ether.inet.proxyall=1 >/dev/null 2>&1 && \
    sudo sysctl -w net.inet.ip.forwarding=1 >/dev/null 2>&1 && \
    if ! sh "$scripts_path/is_macos.sh"; then sudo sysctl -w net.inet.ip.fw.enable=1 >/dev/null 2>&1; fi && \
    sudo ifconfig "$bridgeName" create && \
    sh "$scripts_path/bind_interfaces_to_bridge.sh" "$bridgeName" "$tap"; then

      echo "$bridgeName: Network bridge created"
  else

    echo "ERROR: $bridgeName: Network bridge was not created"
    sh "$scripts_path/fail_and_cleanup.sh" "$tap"
  fi
else

  echo "$bridgeName: Network bridge is available"
fi