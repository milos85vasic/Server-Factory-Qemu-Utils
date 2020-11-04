#!/bin/sh

tap=$1
bridgeName=$(sh create_and_get_bridge.sh "$tap")
echo "$bridgeName: Network bridge is ready and bound to '$tap'"