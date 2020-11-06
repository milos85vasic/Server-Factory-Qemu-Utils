#!/bin/sh

tap=$1

export IFS=";"
qemu_scripts=$(sh get_dependencies.sh)
for script in $qemu_scripts; do

  script_full="/etc/$script"
  if test -e "$script_full"; then

    echo "$script_full: Scrip is already available"
  else

    if sudo cp "$script" /etc; then

      echo "$script_full: Scrip is installed"
    else

      echo "ERROR: $script_full scrip was not installed"
      sh fail_and_cleanup.sh "$tap"
    fi
  fi
done