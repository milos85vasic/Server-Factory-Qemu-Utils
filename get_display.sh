#!/bin/sh

if sh is_macos.sh; then

  echo "cocoa"
else

  if uname | grep -i "linux" >/dev/null 2>&1; then

    echo "gtk"
  else

    echo "sdl"
  fi
fi

