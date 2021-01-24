#!/bin/sh

echo "$@"[0]

path='/Users/vr/Library/Developer/Xcode/DerivedData/CoreDataDemo-guooahfmsyxdcwdisqlammttudui/Build/Products/Debug-iphonesimulator/CoreDataDemo.app'

for device in "$@"

do
    xcrun simctl boot $device
    xcrun simctl install $device $path
    
done

open -a Simulator
    



