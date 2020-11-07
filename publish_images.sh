#!/bin/sh

image_sync_settings="image_sync.settings"
image_location_settings="image_location.settings"

if test -e "$image_location_settings"; then

  source=$(cat "$image_location_settings")
  if [ ! -d "$source" ]
  then

      echo "Synchronization path unavailable: $source"
  else

      if test -e "$image_sync_settings"; then

        command=$(cat "$image_sync_settings")
        if "$command"; then

            echo "Sync. completed"
        else

            echo "Failed to synchronize drive."
            exit 1
        fi
      else

        exit 1
        echo "ERROR: $image_location_settings not available, please create file and add sync. parameters"
      fi
  fi
else

  exit 1
  echo "ERROR: $image_location_settings not available, please create file and add absolute path to images to it"
fi