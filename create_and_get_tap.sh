#!/bin/sh

for ITER in 0 .. 100
do

  tap="tap$ITER"
  if ! ifconfig "$tap" 2> /dev/null; then

    echo "$tap"
    exit 0
  fi
done

echo "ERROR: Could not obtain tap candidate"
exit 1