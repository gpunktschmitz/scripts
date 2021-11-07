#!/bin/sh

# script takes an argument ($filterargument)
# if the argument is present the devices are filtered to match that argument
#   if the filtered devices results in only one device found that devices will be toggled (allowed/blocked)
# if the argument is not present all blocked devices *but* the "$filtertext" will be listed so that one can be allowed
filtertext="EMV Smartcard Reader"

#--

red="\e[0;91m"
green="\e[0;92m"
reset="\e[0m"

# default action; string to print to console
actionstring="allow"
colour=$green

# check if argument given
if [ $# -eq 0 ]; then
  devicecount=$(usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 !~ pat' | wc -l)
else
  # if no argument given update set filter variable
  filterargument=$1
  devicecount=$(usbguard list-devices | awk -v pat="$filterargument" -F":" '$0 ~ pat' | wc -l)
fi

# exit if no devices found
if [ ${devicecount} -eq 0 ]; then 
  exit
elif [ ${devicecount} -eq 1 ]; then
  devicename=$(usbguard list-devices | awk -v pat="$filterargument" -F":" '$0 ~ pat' | grep -o ' name .* hash ' | awk 'BEGIN {FS="\""}{print $2}' | xargs)
  devicestatus=$(usbguard list-devices | awk -v pat="$filterargument" -F":" '$0 ~ pat' |  cut -d' ' -f2)
  # if devicestatus is "allow" the device will be blocked; update variable to print to console
  if [ "${devicestatus}" = "allow" ]; then
    actionstring="block"
    colour=$red
  fi

  # print the action and device name
  echo -e "${colour}"$(printf "%sing USB device \"%s\"\n" "${actionstring}" "${devicename}")"${reset}"

  if [ $# -eq 0 ]; then
    sudo usbguard allow-device $(usbguard list-devices --blocked | awk -v pat="$filtertext" -F":" '$0 !~ pat' | awk -F: '{print $1}')
  else
    if [ "${devicestatus}" = "allow" ]; then
      sudo usbguard block-device $(usbguard list-devices | awk -v pat="$filterargument" -F":" '$0 ~ pat' | awk -F: '{print $1}')
    else
      sudo usbguard allow-device $(usbguard list-devices | awk -v pat="$filterargument" -F":" '$0 ~ pat' | awk -F: '{print $1}')
    fi
  fi
else
  # if more than one device was found prompt for the id of the one to be allowed/blocked
  printf "found %s devices\n" "${devicecount}"
  if [ $# -eq 0 ]; then
    usbguard list-devices | awk -v pat="$filtertext" -F":" '$0 !~ pat'
  else
    usbguard list-devices | awk -v pat="$filterargument" -F":" '$0 ~ pat'
  fi

  userinput=""
  read -p "Input selection (id): " userinput

  if [ -z "$userinput" ]; then
    exit
  else
    devicestatus=$(usbguard list-devices | awk -v pat="$userinput: " -F":" '$0 ~ pat' |  cut -d' ' -f2)
    if [[ "${devicestatus}" -eq "allow" ]]; then
      sudo usbguard block-device ${userinput}
    else
      sudo usbguard allow-device ${userinput}
    fi
  fi
fi
