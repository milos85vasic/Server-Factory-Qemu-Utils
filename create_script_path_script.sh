#!/bin/sh

tap=$1
script_path="/tmp"
current_script_path=$(pwd)
script_path_full="$script_path/qemu_scripts_path.sh"

if test -e "$script_path_full"; then

  if sudo rm -f "$script_path_full"; then

    echo "Script removed: $script_path_full"
  else

    echo "Script not removed: $script_path_full"
    sh fail_and_cleanup.sh "$tap"
  fi
fi

if echo """
#!/bin/sh

echo $current_script_path
""" | tee "$script_path_full" && chmod 750 "$script_path_full"; then

  echo "Script installed: $script_path_full"
else

  echo "Script not installed: $script_path_full"
  sh fail_and_cleanup.sh "$tap"
fi