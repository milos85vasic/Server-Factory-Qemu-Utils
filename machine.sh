#!/bin/sh

tap=$(sh create_and_get_tap.sh)
sh create_script_path_script.sh "$tap"
sh create_dependencies.sh "$tap"

iso=$2
machine=$1
display=$(sh get_display.sh)
acceleration=$(sh get_acceleration.sh)
disk=$(sh create_disk.sh "$machine" 20 "$tap")

sudo qemu-system-x86_64 -accel "$acceleration" -cpu host -m 2048 -smp 2 \
  -display "$display",show-cursor=on -usb -device usb-tablet -vga virtio \
  -drive file="$disk,format=qcow2,if=virtio" \
  -net nic -net tap,ifname="$tap" \
  -cdrom "$iso"
