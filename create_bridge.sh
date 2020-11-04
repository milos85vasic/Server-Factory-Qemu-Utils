#!/bin/sh

bridgeName=$1

if ! ifconfig "$bridgeName" >/dev/null 2>&1; then

  echo "$bridgeName: Creating network bridge"
  if sudo sysctl -w net.link.ether.inet.proxyall=1 > /dev/null && \
    sudo sysctl -w net.inet.ip.forwarding=1 > /dev/null && \
    # TODO: macOS
    # sudo sysctl -w net.inet.ip.fw.enable=1 > /dev/null && \
    sudo ifconfig "$bridgeName" create; then

      echo "$bridgeName: Network bridge created"
  else

    echo "ERROR: $bridgeName: Network bridge was not created"
    exit 1
  fi
else

  echo "$bridgeName: Network bridge is available"
fi