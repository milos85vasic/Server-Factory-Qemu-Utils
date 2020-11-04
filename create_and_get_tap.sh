#!/bin/sh

END=100
for ITER in $(seq 0 $END);
do

  tap="tap$ITER"
  if ! ifconfig "$tap" >/dev/null 2>&1; then

    echo "$tap"
    exit 0
  fi
done

echo "ERROR: Could not obtain tap candidate"
exit 1