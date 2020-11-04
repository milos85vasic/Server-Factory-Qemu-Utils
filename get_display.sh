#!/bin/sh

if uname | grep -i "darwin" >/dev/null 2>&1; then

  echo "cocoa"
else

  if uname | grep -i "linux" >/dev/null 2>&1; then

    echo "gtk"
  else

    echo "sdl"
  fi
fi

