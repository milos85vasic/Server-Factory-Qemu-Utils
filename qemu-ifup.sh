#!/bin/bash

echo "Executing /etc/qemu-ifup"
if sh create_network.sh; then

  echo "$1: Bringing up for bridged mode"
  if ifconfig "$1" 0.0.0.0 up; then

    echo "$1: Adding to bridge"
    if ifconfig bridge0 addm en0 addm "$1"; then

      echo "$1: Added to bridge"
    else

      echo "ERROR: $1 failed to add to bridge"
      exit 1
    fi
  else

    echo "ERROR: $1 could not bring up for bridged mode"
    exit 1
  fi
else

  echo "ERROR: Could not bring up the network"
  exit 1
fi