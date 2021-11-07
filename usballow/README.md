# usballow
I am using `usbguard` to allow/block usb devices.

If only one devices is filtered/selected it will be toggled (allowed/disabled) - when there are more devices one gets prompted to select which one to be toggled. 

If more than one are present the command `usbguard list-devices --blocked` is executed and expects the device no. to be entered which then will be allowed.

## my usage
I use this script on Linux Mint.
I added the shortcut `CTRl+ALT+U` to the `Keyboard Shortcuts` app executing `mate-terminal -e 'bash /home/myveryusername/scripts/usballow/usballow.sh'` to allow any device not matching the `$filtertext` variable.
I added the shortcut `CTRL+ALT+C` to the `Keyboard Shortcuts` app executing `mate-terminal -e 'bash /home/myveryusername/scripts/usballow/usballow.sh "EMV Smartcard Reader"'` to toggle only the device matching the `$filterargument` variable.

