#!/bin/sh

dependencies="create_and_get_bridge.sh;create_bridge.sh;create_network.sh;delete_bridge.sh;"

if_up_script="qemu-ifup"
if_down_script="qemu-ifdown"
if_up_script_full="/etc/$if_up_script"
if_down_script_full="/etc/$if_down_script"

export IFS=";"
qemu_scripts="$if_up_script_full;$if_down_script_full;$dependencies"
for script in $qemu_scripts; do

  script_backup="${script}_"
  if test -e "$script" && ! test -e "$script_backup"; then

    if mv "$script" "$script_backup"; then

      echo "$script backed up to: $script_backup"
    else

      echo "$script was not backed up to: $script_backup"
      exit 1
    fi
  fi

  echo "$script: Scrip will be installed"
  if sudo cp "$script" /etc; then

    echo "$script: Scrip is installed"
  else

    echo "$script: Scrip was not installed"
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
    -netdev tap,id=tap1 -device rtl8139,netdev=tap1 \
    -cdrom "$iso"

# -net nic -net tap,ifname=tap0 \
