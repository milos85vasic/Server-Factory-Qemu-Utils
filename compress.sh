#!/bin/sh

what=$1
check=$2
output="$what.tar.gz"

if [ -z "$check" ]
then

  output="$what.tar.gz"
else

  output="$what/$check/$(basename "$what").tar.gz"
fi

if test -e "$output"; then

  echo "Skipping: $what, compressed file already exist: $output"
else

  echo "Compressing: $what"
  tar -cjf "$output" -C "$what" .
fi