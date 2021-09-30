#!/bin/sh

blockeddevicescount=$(usbguard list-devices --blocked | wc -l)
if [[ "${blockeddevicescount}" == "0" ]]; then
  exit
elif [[ "${blockeddevicescount}" == "1" ]]; then
  devicename=$(usbguard list-devices --blocked | grep -o ' name .* hash ' | awk 'BEGIN {FS="\""}{print $2}' | xargs)
  printf "activating USB device \"%s\"\n" "${devicename}"
  sudo usbguard allow-device $(usbguard list-devices --blocked | awk -F: '{print $1}')
else
  printf "found %s devices\n" "${blockeddevicescount}"
  usbguard list-devices --blocked
  userinput=""
  read -p "Input Selection: " userinput
  if [ -z "$userinput" ]; then
    exit
  else
    sudo usbguard allow-device ${userinput}
  fi
fi
