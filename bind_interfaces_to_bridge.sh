#!/bin/sh

tap=$2
bridgeName=$1
interface="en0"

if sudo ifconfig "$bridgeName" addm "$interface"; then

  echo "$bridgeName: Bound with: $interface"
  exit 0
else

  echo "$bridgeName: Failed to bind with: $interface"
  sh fail_and_cleanup.sh "$tap"
fi
