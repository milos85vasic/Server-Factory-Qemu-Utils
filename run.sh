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

  image_location_properties="image_location.properties"
  image_provider_properties="image_provider.properties"
  if test -e "$image_location_properties"; then

    image_location=$(cat "$image_location_properties")
    echo "Images location: $image_location"
  else

    echo "image_location.properties: Not available, please create file and add absolute path to images to it"
  fi
fi

# sh machine.sh "$machine" "$iso"