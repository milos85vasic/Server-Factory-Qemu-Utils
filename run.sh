#!/bin/sh

iso=$2
machine=$1

echo "Checking system image availability"
disk="disk.qcow2"
image="$machine/$disk"
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

      echo "Images location search path: $image_location"
      if ! test -e "$image"; then

        if ! mkdir -p "$machine"; then

          echo "ERROR: $machine directory could not be created"
          exit 1
        fi
      fi

      system=$(basename "$machine")
      obtain_image="$image_location/$system"
      obtain_image_disk="$obtain_image/$disk"

      echo "Looking for image: $obtain_image"
      if test -e "$obtain_image_disk"; then

        echo "Found: $obtain_image_disk"
        echo "Deploying to: $machine"
      else

        echo "WARNING: $obtain_image_disk has not been found"
        echo "Downloading: $system into $obtain_image"

        if test -e "$image_provider_settings"; then

          provider_url=$(cat "$image_provider_settings")
          url="$provider_url/$system.gz"
          download_destination="/tmp"
          if wget -P "$download_destination" "$url"; then

            echo "Image downloaded"
          else

            echo "ERROR: Image download failed"
            exit 1
          fi
        else

          exit 1
          echo "ERROR: $image_provider_settings not available, please create file and add images server url to it"
        fi
      fi

      # TODO: Deploy
    else

      echo "ERROR: $image_location images location path does not exist"
      exit 1
    fi
  else

    exit 1
    echo "ERROR: $image_location_settings not available, please create file and add absolute path to images to it"
  fi
fi

# sh machine.sh "$machine" "$iso"
