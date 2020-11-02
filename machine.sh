#!/bin/sh

export IFS=";"
qemu_scripts="qemu-ifup;qemu-ifdown;create_and_get_bridge.sh;create_bridge.sh;create_network.sh;delete_bridge.sh"
for script in $qemu_scripts; do

  script_full="/etc/$script"
  script_backup="${script_full}_"

  if test -e "$script_full" && ! test -e "$script_backup"; then

    if sudo mv "$script_full" "$script_backup"; then

      echo "$script_full: backed up to: $script_backup"
    else

      echo "ERROR: $script_full was not backed up to: $script_backup"
      exit 1
    fi
  fi

  if sudo cp "$script" /etc; then

    echo "$script_full: Scrip is installed"
  else

    echo "ERROR: $script_full scrip was not installed"
    exit 1
  fi
done

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
    -net nic -net tap,ifname=tap0 \
    -cdrom "$iso"

# -net nic -net tap,ifname=tap0 \
#-netdev tap,id=tap2 -device rtl8139,netdev=tap2 \