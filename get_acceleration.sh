#!/bin/sh

if sh is_macos.sh; then

  echo "hvf"
else

  if uname | grep -i "linux" >/dev/null 2>&1; then

    echo "kvm"
  else

    echo "tcg"
  fi
fi

