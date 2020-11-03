#!/bin/sh

bridgeName=$(sh create_and_get_bridge.sh "$1")
echo "$bridgeName: Network bridge is ready and bound to '$1'"