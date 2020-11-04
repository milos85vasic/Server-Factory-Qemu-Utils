#!/bin/sh

if uname | grep -i "darwin" >/dev/null 2>&1; then

  echo "hvf"
else

  if uname | grep -i "linux" >/dev/null 2>&1; then

    echo "kvm"
  else

    echo "tcg"
  fi
fi

