#!/bin/sh

END=100
for ITER in $(seq 0 $END);
do

  tap="tap$ITER"
  if ! ifconfig "$tap" 2> /dev/null; then

    echo "$tap"
    exit 0
  fi
done

echo "ERROR: Could not obtain tap candidate"
exit 1