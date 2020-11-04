#!/bin/sh

END=100
for ITER in $(seq 0 $END);
do

  tap="tap$ITER"
  if ! ifconfig "$tap" >/dev/null 2>&1; then

    log=$(sh get_machine_log_name.sh "$tap")
    if test -e "$log"; then

      sudo rm -f "$log" >/dev/null 2>&1
      echo "Qemu machine running at '$tap' already exist"
    fi

    if sudo touch "$log" && \
      sudo chmod 640 "$log" && \
      sudo echo "Machine started: $(date)" | sudo tee -a "$log" >/dev/null 2>&1; then

        echo "$tap"
        exit 0
    else

      echo "Qemu machine not started at: $tap"
      sh fail.sh
    fi
  fi
done

echo "ERROR: Could not obtain tap candidate"
sh fail.sh