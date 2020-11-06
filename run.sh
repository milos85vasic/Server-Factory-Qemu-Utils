#!/bin/sh

iso=$2
machine=$1

echo "Checking system image availability"
image="$machine/disk.qcow2"
if test -e "$image"; then

  echo "$image: Is available"
else

  echo "$image: Is not available"
  echo "$image: Obtaining"

  image_location_settings="image_location.settings"
  image_provider_settings="image_provider.settings"
  if test -e "$image_location_settings"; then

    image_location=$(cat "$image_location_settings")
    if test -e "$image_location"; then

      echo "Images location path: $image_location"
    else

      echo "Images location path does not exist: $image_location"
      exit 1
    fi
  else

    echo "$image_location_settings: Not available, please create file and add absolute path to images to it"
  fi
fi

# sh machine.sh "$machine" "$iso"