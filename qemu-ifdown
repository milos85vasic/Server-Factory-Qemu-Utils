#!/bin/bash

echo "Executing /etc/qemu-ifdown"
if sh delete_bridge.sh; then

  echo "Bridge has been destroyed"
else

  echo "ERROR: Bridge was not destroyed"
fi