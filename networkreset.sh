#!/usr/bin/env bash

echo "[+] Backing up configuration files"

## declare an array variable
declare -a arr=("com.apple.airport.preferences.plist" "com.apple.network.indentification.plist"
"NetworkInterfaces.plist" "preferences.plist")

mkdir ~/networkbackup

## now loop through the above array
for i in "${arr[@]}"
do
   echo "-> Backing up $i"
   cp /Library/Preferences/SystemConfiguration/$i ~/networkbackup
   echo "----"
   # or do whatever with individual element of the array
done


