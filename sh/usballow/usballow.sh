#!/bin/sh

# list only blocked devices: id and device name
usbguard list-devices --blocked | awk -F\" '{print $1 $4}' | cut -d" " -f1-1,6-

# get id from user
read -p "enter id to unblock device: " userinput

# test if userinput variable is empty
if [ -z "${userinput}" ]; then
  exit
else
  # allow device temporary (until device is unplugged or user logs off)
  sudo usbguard allow-device ${userinput}
fi
