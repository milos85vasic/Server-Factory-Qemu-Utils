#!/bin/sh

if sh is_macos.sh; then

  echo "-accel hvf"
else

  if uname | grep -i "linux" >/dev/null 2>&1; then

    echo "-enable-kvm"
  else

    echo "-accel tcg"
  fi
fi

