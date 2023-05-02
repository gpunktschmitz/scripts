# usballow
I am using `usbguard` to allow/block usb devices.

This script lists all blocked devices and expects the id of the device listed to be entered. It then tries to unblock the device with the given id.

## my usage
I use this script on Linux Mint and added the following shortcut to the app `Keyboard Shortcuts`.

`CTRl+ALT+U` executing `mate-terminal -e 'bash /path/to/script/usballow.sh'`
