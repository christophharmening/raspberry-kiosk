#!/bin/bash

xset s noblank
xset s off
xset -dpms

unclutter &

chromium --noerrdialogs --disable-infobars --kiosk -URL- &

while true ; do
	sleep -TIME-
	xdotool key F5
done
