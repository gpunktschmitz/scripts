#!/bin/sh

#script takes an argument if it is present (no matter what its called)
#if the argument is present only "$filtertext" will be unblocked
#if the argument is not present all blocked devices *but* the "$filtertext" will be unblocked
filtertext='"EMV Smartcard Reader"'

#--

filterargument=$1
if [ $# -eq 0 ]; then
  blockeddevicescount=$(usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 !~ pat' | wc -l)
else
  blockeddevicescount=$(usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 ~ pat' | wc -l)
fi

if [[ "${blockeddevicescount}" == "0" ]]; then
  exit
elif [[ "${blockeddevicescount}" == "1" ]]; then
  if [ $# -eq 0 ]; then
    devicename=$(usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 !~ pat' | grep -o ' name .* hash ' | awk 'BEGIN {FS="\""}{print $2}' | xargs)
  else
    devicename=$(usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 ~ pat' | grep -o ' name .* hash ' | awk 'BEGIN {FS="\""}{print $2}' | xargs)
  fi
  printf "activating USB device \"%s\"\n" "${devicename}"
  if [ $# -eq 0 ]; then
    sudo usbguard allow-device $(usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 !~ pat' | awk -F: '{print $1}')
  else
    sudo usbguard allow-device $(usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 ~ pat' | awk -F: '{print $1}')
  fi
else
  printf "found %s devices\n" "${blockeddevicescount}"
  if [ $# -eq 0 ]; then
    usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 !~ pat'
  else
    usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 ~ pat'
  fi
  userinput=""
  read -p "Input Selection: " userinput
  if [ -z "$userinput" ]; then
    exit
  else
    sudo usbguard allow-device ${userinput}
  fi
fi
