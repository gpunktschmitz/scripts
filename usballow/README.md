# usballow
I am using `usbguard` to allow/block several usb devices.

This script prompts for the sudo password if only one unblocked and not-yet-allowed usb device is connected.

If more than one are present the command `usbguard list-devices --blocked` is executed and expects the device no. to be entered which then will be allowed.

## my usage
I use this script on Linux Mint.
I added the shortcut `CTRl+ALT+U` to the `Keyboard Shortcuts` app executing `mate-terminal -e 'bash /home/myveryusername/scripts/usballow/usballow.sh'` to allow any device not matching the `$filtertext` variable.
I added the shortcut `CTRL+ALT+C` to the `Keyboard Shortcuts` app executing `mate-terminal -e 'bash /home/myveryusername/scripts/usballow/usballow.sh smartcardreader'` to allow only the device matching the `$filtertext` variable.

