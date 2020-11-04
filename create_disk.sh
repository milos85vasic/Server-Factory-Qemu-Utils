#!/bin/sh

tap=$3
size=$2
diskPath=$1
disk="$diskPath/disk.qcow2"

if ! test -e "$disk"; then

  mkdir -p "$diskPath"
  if ! qemu-img create -f qcow2 "$disk" "${size}G" >/dev/null 2>&1; then

    echo "$disk was not created"
    sh fail_and_cleanup.sh "$tap"
  fi
fi

echo "$disk"
