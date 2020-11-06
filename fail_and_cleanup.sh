#!/bin/bash

tap=$1
scripts_path=$(sh "/tmp/qemu_scripts_path.sh")

sh "$scripts_path/delete_bridge.sh" "$tap"
exit 1