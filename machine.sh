#!/bin/sh

if_up_script="qemu-ifup"
if_up_script_full="/etc/$if_up_script"
if_up_script_backup="/etc/_$if_up_script"

if test -e "$if_up_script_full" && ! test -e "$if_up_script_backup"; then

  if mv "$if_up_script_full" "$if_up_script_backup"; then

    echo "$if_up_script_full backed up to: $if_up_script_backup"
  else

    echo "$if_up_script_full was not backed up to: $if_up_script_backup"
    exit 1
  fi
fi

if ! test -e /etc/qemu-ifup; then

  echo "qemu-ifup: Scrip version for macOS is missing, it will be installed"
  if sudo cp macOS/qemu-ifup.sh /etc && sudo mv /etc/qemu-ifup.sh /etc/qemu-ifup; then

    echo "qemu-ifup: Scrip version for macOS is installed"
  else

    echo "qemu-ifup: Scrip version for macOS was not installed"
    exit 1
  fi
fi

iso=$2
machine=$1
display=$(sh get_display.sh)
acceleration=$(sh get_acceleration.sh)
disk=$(sh create_disk.sh "$machine" 20)
#tapName=$(sh create_and_get_tap.sh)
#bridgeName=$(sh create_and_get_bridge.sh)

#  ip link set "$tapName" master "$bridgeName"
  sudo qemu-system-x86_64 -accel "$acceleration" -cpu host -m 2048 -smp 2 \
    -display "$display",show-cursor=on -usb -device usb-tablet -vga virtio \
    -drive file="$disk,format=qcow2,if=virtio" \
    -netdev tap,id=tap1 -device rtl8139,netdev=tap1 \
    -cdrom "$iso"

# -net nic -net tap,ifname=tap0 \
