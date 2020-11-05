#!/bin/sh

tap=$2
bridgeName=$1
log=$(sh get_machine_log_name.sh "$tap")

echo "Binding interfaces" | sudo tee -a "$log"
interfaces="en0;en1;en2;en3;en4;en5;eth0;eth1;eth2;eth3;eth4;eth5"
export IFS=";"
for interface in $interfaces; do

  if sudo ifconfig "$bridgeName" addm "$interface"; then

      echo "$bridgeName: Bound with $interface" | sudo tee -a "$log"
    else

      echo "$bridgeName: Not bound with $interface" | sudo tee -a "$log"
    fi
done