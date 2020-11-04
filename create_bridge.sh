#!/bin/sh

tap=$2
bridgeName=$1

if ! ifconfig "$bridgeName" >/dev/null 2>&1; then

  echo "$bridgeName: Creating network bridge"
  if sudo sysctl -w net.link.ether.inet.proxyall=1 >/dev/null 2>&1 && \
    sudo sysctl -w net.inet.ip.forwarding=1 >/dev/null 2>&1 && \
    # TODO: macOS
    # sudo sysctl -w net.inet.ip.fw.enable=1 >/dev/null 2>&1 && \
    sudo ifconfig "$bridgeName" create && \
    sh bind_interfaces_to_bridge.sh "$bridgeName" "$tap"; then

      echo "$bridgeName: Network bridge created"
  else

    echo "ERROR: $bridgeName: Network bridge was not created"
    sh fail_and_cleanup.sh "$tap"
  fi
else

  echo "$bridgeName: Network bridge is available"
fi