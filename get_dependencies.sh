#!/bin/sh

macos="is_macos.sh"
log="get_machine_log_name.sh"
fail="fail_and_cleanup.sh;fail.sh"
dependencies="get_dependencies.sh"
if_up_down="qemu-ifup;qemu-ifdown"
counter="get_running_machines_count.sh"
interfaces="bind_interfaces_to_bridge.sh"
bridge="create_and_get_bridge.sh;create_bridge.sh;delete_bridge.sh"
echo "$if_up_down;$bridge;$dependencies;$interfaces;$counter;$log;$fail;$macos"