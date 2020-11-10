#!/bin/sh

tap=$(sh create_and_get_tap.sh)
sh create_script_path_script.sh "$tap"
sh create_dependencies.sh "$tap"

iso=$2
machine=$1
display=$(sh get_display.sh)
acceleration=$(sh get_acceleration.sh)
disk=$(sh create_disk.sh "$machine" 20 "$tap")

if sh is_macos.sh; then

  sleep_lock="caffeinate"
else

  sleep_lock="sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target --runtime &&"
fi

if ! sudo "$sleep_lock" qemu-system-x86_64 -accel "$acceleration" -cpu host -m 3072 -smp 3 \
  -display "$display",show-cursor=on -usb -device usb-tablet -vga virtio \
  -drive file="$disk,format=qcow2,if=virtio" \
  -net nic -net tap,ifname="$tap" \
  -cdrom "$iso"; then

  echo "ERROR: Qemu machine could not start"
  sh fail_and_cleanup.sh "$tap"
fi
