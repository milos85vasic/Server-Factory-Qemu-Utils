#!/bin/bash

echo "Executing /etc/qemu-ifup"
if sh create_network.sh; then

  echo "$1: Bringing up for bridged mode"
  if ifconfig $1 0.0.0.0 up; then

    echo "Add $1 to bridge"
    ifconfig bridge0 addm en0 addm $1
    echo "Bring up bridge"
    ifconfig bridge0 up
  else

    echo "ERROR: $1 could not bring up for bridged mode"
    exit 1
  fi
else

  echo "ERROR: Could not bring up the network"
  exit 1
fi