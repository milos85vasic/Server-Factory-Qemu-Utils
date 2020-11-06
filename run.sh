#!/bin/sh

iso=$2
machine=$1

echo "Checking system image availability"
image="$machine/disk.qcow2"
if test -e "$image"; then

  echo "$image: Is available"
else

  echo "$image: Is not available"
  echo "$image: Obtaining"

fi

sh machine.sh "$machine" "$iso"