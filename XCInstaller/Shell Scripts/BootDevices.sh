#!/bin/sh

echo "$@"

for device in "$@"

do
    xcrun simctl boot $device
    
done
    



