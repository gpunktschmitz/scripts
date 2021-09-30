# usballow
I am using `usbguard` to allow/block several usb devices.

This script prompts for the sudo password if only one unblocked and not-yet-allowed usb device is connected.

If more than one are present the command `usbguard list-devices --blocked` is executed and expects the device no. to be entered which then will be allowed.

## Linux Mint
I use this script by mapping `mate-terminal -e 'bash /home/myveryusername/scripts/usballow/usballow.sh'` to `CTRl+ALT+U` via the app `Keyboard Shortcuts`.
