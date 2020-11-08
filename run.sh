#!/bin/sh

iso=$2
machine=$1

if [ -z "$iso" ]
then

  echo "No iso image provided"
else

  echo "Checking iso image: $iso"
  iso_location_settings="iso_location.settings"
  iso_provider_settings="iso_provider.settings"

  if test -e "$iso_location_settings"; then

    iso_location=$(cat "$iso_location_settings")
    if test -e "$iso_location"; then

      echo "Iso(s) location search path: $iso_location"
      full_iso="$iso_location/$iso"
      if test -e "$obtain_image_disk"; then

        echo "$full_iso: Found"
      else

        echo "WARNING: $full_iso has not been found"
        echo "Downloading: $iso into $iso_location"

        if test -e "$iso_provider_settings"; then

          iso_provider_url=$(cat "$iso_provider_settings")
          iso_url="$iso_provider_url/Images/Iso/$iso"
          iso_download_destination="$iso_location"
          if wget -P "$iso_download_destination" "$iso_url"; then

            echo "Iso downloaded"
          else

            echo "ERROR: Iso download failed"
            exit 1
          fi
        fi
      fi
    else

      echo "ERROR: $iso_location iso(s) location search path does not exist"
      exit 1
    fi
  else

    exit 1
    echo "ERROR: $iso_location_settings not available, please create file and add absolute path to iso(s) to it"
  fi
fi

echo "Checking system image availability"
disk="disk.qcow2"
image="$machine/$disk"
if test -e "$image"; then

  echo "$image: Is ready"
else

  echo "$image: Is not available"
  echo "$image: Obtaining"

  image_location_settings="image_location.settings"
  image_provider_settings="image_provider.settings"
  if test -e "$image_location_settings"; then

    image_location=$(cat "$image_location_settings")/Uncompressed
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

        echo "$obtain_image_disk: Found, deploying to: $machine"
      else

        echo "WARNING: $obtain_image_disk has not been found"
        echo "Downloading: $system into $obtain_image"

        if test -e "$image_provider_settings"; then

          provider_url=$(cat "$image_provider_settings")
          url="$provider_url/Images/Qemu/$system.tar.gz"
          download_destination="/tmp"
          if wget -P "$download_destination" "$url"; then

            echo "Image downloaded"
            echo "Extracting image into: $obtain_image"
            if ! test -e "$obtain_image"; then

              if mkdir -p "$obtain_image"; then

                echo "$obtain_image: Directory created"
              else

                echo "ERROR: $obtain_image directory not created"
                exit 1
              fi
            fi
            if tar -xf "$download_destination/$system.tar.gz" -C "$obtain_image"; then

              echo "Image is ready"
            else

              echo "ERROR: Could not extract image"
              exit 1
            fi
          else

            echo "ERROR: Image download failed"
            exit 1
          fi
        else

          exit 1
          echo "ERROR: $image_provider_settings not available, please create file and add images server url to it"
        fi
      fi

      if cp -a "$obtain_image/" "$machine"; then

        echo "$obtain_image deployed to: $machine"
      else

        echo "$obtain_image was not deployed to: $machine"
        exit 1
      fi
    else

      echo "ERROR: $image_location images location search path does not exist"
      exit 1
    fi
  else

    exit 1
    echo "ERROR: $image_location_settings not available, please create file and add absolute path to images to it"
  fi
fi

sh machine.sh "$machine" "$full_iso"
