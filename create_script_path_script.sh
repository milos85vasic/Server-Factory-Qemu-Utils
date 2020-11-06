#!/bin/sh

tap=$1
script_path="/tmp"
current_script_path=$(pwd)
count=$(sh "get_running_machines_count.sh")
script_path_full="$script_path/qemu_scripts_path.sh"

if test -e "$script_path_full"; then

  if [ "$count" = "1" ] || [ "$count" = "0"  ]; then
    if sudo rm -f "$script_path_full"; then

      echo "Script removed: $script_path_full"
    else

      echo "Script not removed: $script_path_full"
      sh fail_and_cleanup.sh "$tap"
    fi
  fi
fi

if [ "$count" = "1" ] || [ "$count" = "0"  ]; then

  if test -e "$script_path_full"; then

    echo "$script_path_full: Script is already available"
  else

    if echo """
    #!/bin/sh

    echo $current_script_path
    """ | tee "$script_path_full" >/dev/null 2>&1 && chmod 750 "$script_path_full"; then

      echo "$script_path_full Script is installed"
    else

      echo "$script_path_full: Script is not installed"
      sh fail_and_cleanup.sh "$tap"
    fi
  fi
fi