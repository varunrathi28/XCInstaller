#!/bin/sh

open -a Simulator

echo "$@[1:]"

path=$1

for device in "$@"

do
    xcrun simctl boot $device
    xcrun simctl install $device $path
    
done

#xcrun simctl launch booted
    



