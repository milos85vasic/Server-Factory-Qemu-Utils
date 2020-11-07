#!/bin/sh

image_sync_script="image_sync.sh"
image_location_settings="image_location.settings"

if test -e "$image_location_settings"; then

  source=$(cat "$image_location_settings")
  if ! test -e "$source"; then

      echo "Synchronization path unavailable: $source"
  else

      find "$source" ! -path "$source" ! -path '*/\.*' -maxdepth 1 -exec tar -cjf {}.tar.gz -C {} . \; >/dev/null 2>&1
      if test -e "$image_sync_script"; then

        if sh "$image_sync_script" "$source"; then

            echo "Sync. completed"
        else

            echo "Failed to synchronize drive."
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