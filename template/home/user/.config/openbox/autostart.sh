#!/bin/bash

# Kein Bildschirmschoner
xset s noblank
xset s off
xset -dpms

# Kein Mauszeiger
unclutter &

# Nach bestimmter Uhrzeit Monitor aus
disable_screen &

# Chrome starten
chromium-browser --noerrdialogs --disable-infobars --kiosk -URL- &

# Chrome aktualisieren
while true ; do
	sleep -TIME-
	xdotool key F5
done
