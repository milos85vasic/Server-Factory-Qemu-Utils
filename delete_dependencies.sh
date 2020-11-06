#!/bin/sh

tap=$1
scripts_path_script="/tmp/qemu_scripts_path.sh"
scripts_path=$(sh "$scripts_path_script")
qemu_scripts=$(sh "$scripts_path/get_dependencies.sh")
count=$(sh "$scripts_path/get_running_machines_count.sh")

if [ "$count" = "1" ] || [ "$count" = "0"  ]; then

  export IFS=";"
  for script in $qemu_scripts; do

    script_full="/etc/$script"
    if test -e "$script_full"; then
      if sudo rm -f "$script_full"; then

        echo "$script_full: Is removed"
      else

        echo "ERROR: $script_full was not removed"
        sh "$scripts_path/fail_and_cleanup.sh" "$tap"
      fi
    fi
  done

  if test -e "$scripts_path_script"; then

    if rm -f "$scripts_path_script"; then

      echo "$scripts_path_script: Is removed"
    else

      echo "$scripts_path_script: Is not removed"
      sh "$scripts_path/fail_and_cleanup.sh" "$tap"
    fi
  else

    echo "$scripts_path_script: Script is already removed"
  fi
fi