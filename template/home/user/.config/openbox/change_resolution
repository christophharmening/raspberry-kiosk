#!/bin/bash

# Script change the  display resolution for the user nutzer in openbox

# OpenBox autostart file
file=/home/nutzer/.config/openbox/autostart

# Get the avaiable resolution for this system
resolutions=$(xrandr | grep -oP '\d+x\d+' | sort -n | uniq)

# Show a dialog box with the avaiables resolutions
resolution=$(zenity --list --title "Select resolutions" --column "Resolutions" ${resolutions})

# Set the selected resolution
# Set temp
xrandr -s ${resolution}

# Set in file
if grep xrandr ${file} > /dev/null ; then
	sed -i "s/^xrandr.*/xrandr -s ${resolution}/g" ${file}
else
	echo "xrandr -s ${resolution}" >> ${file}
fi

exit 0
