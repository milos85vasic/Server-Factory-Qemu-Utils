#!/bin/sh

script_path="/tmp"
count=$(find "$script_path" -type f -name "$script_path/qemu_machine_*.log" | wc -l | xargs)
echo "$count"