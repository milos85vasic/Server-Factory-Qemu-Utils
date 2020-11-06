#!/bin/sh

tap=$(sh create_and_get_tap.sh)
sh create_script_path_script.sh "$tap"

export IFS=";"
qemu_scripts=$(sh get_dependencies.sh)
for script in $qemu_scripts; do

  script_full="/etc/$script"
  if test -e "$script_full"; then

    echo "$script_full: Scrip is already available"
  else

    if sudo cp "$script" /etc; then

      echo "$script_full: Scrip is installed"
    else

      echo "ERROR: $script_full scrip was not installed"
      sh fail_and_cleanup.sh "$tap"
    fi
  fi
done

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
