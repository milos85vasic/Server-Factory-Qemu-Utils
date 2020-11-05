#!/bin/sh

count="0"
if sudo ls -l /tmp/qemu_machine_*.log >/dev/null 2>&1; then

  count=$(sudo ls -l /tmp/qemu_machine_*.log | wc -l | xargs)
fi
echo "$count"