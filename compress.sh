#!/bin/sh

what=$1
output="$what.tar.gz"

if test -e "$output"; then

  echo "Skipping: $what, compressed file already exist: $output"
else

  echo "Compressing: $what"
  tar -cjf "$output" -C "$what" .
fi