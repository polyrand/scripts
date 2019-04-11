#!/usr/bin/env bash

echo "[+] Backing up configuration files"

## declare an array variable
declare -a arr=("com.apple.airport.preferences.plist" "com.apple.network.indentification.plist"
"NetworkInterfaces.plist" "preferences.plist")

DIRECTORY=~/networkbackup

if [ ! -d "$DIRECTORY" ]; then
  mkdir ~/networkbackup
fi


## now loop through the above array
for i in "${arr[@]}"
do
  FILE=/Library/Preferences/SystemConfiguration/$i
  if [ -f "$FILE" ]; then
    echo "-> Backing up $i"
    cp $FILE ~/networkbackup
    echo "----"
  else
    echo "$FILE does not exist"
  fi
done

if [ $1 == 'remove' ]; then

  for i in "${arr[@]}"
  do
    FILE=/Library/Preferences/SystemConfiguration/$i
    BACKUP=~/networkbackup/$i
    if [ -f "$FILE" ]; then
      if [ -f "$BACKUP" ]; then
        echo "-> Removing  $FILE"
        rm $FILE
        echo "----"
      else
        echo "[!] The file $FILE has not been backed up"
      fi
    else
      echo "$FILE does not exist"
    fi
  done
fi
