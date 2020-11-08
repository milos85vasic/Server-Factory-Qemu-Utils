#!/bin/sh

image_sync_script="image_sync.sh"
image_location_settings="image_location.settings"

if test -e "$image_location_settings"; then

  source=$(cat "$image_location_settings")
  if ! test -e "$source"; then

      echo "Synchronization path unavailable: $source"
  else

      find "$source/Uncompressed" ! -path "$source/Uncompressed" ! -path '*/\.*' \
        -maxdepth 1 -type d -exec sh compress.sh {} "../../Compressed" \; && \
        mv "$source"/Uncompressed/*.tar.gz "$source"/Compressed/ >/dev/null 2>&1

      if test -e "$image_sync_script"; then

        if sh "$image_sync_script" "$source/Compressed/" "Images/Qemu"; then

            echo "Sync. completed"
        else

            echo "Failed to synchronize images"
            exit 1
        fi
      else

        exit 1
        echo "ERROR: $image_location_settings not available, please create sync. script and try again"
      fi
  fi
else

  exit 1
  echo "ERROR: $image_location_settings not available, please create file and add absolute path to images to it"
fi