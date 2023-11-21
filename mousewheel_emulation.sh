#!/bin/sh
export DISPLAY=:0
MOUSE="Logitech M570"
#xinput --set-prop "$MOUSE" 'Evdev Wheel Emulation' 1
#xinput --set-prop "$MOUSE" 'Evdev Wheel Emulation Button' 9
#xinput --set-prop "$MOUSE" 'Evdev Wheel Emulation Axes' 6 7 4 5

##xinput --set-prop "$MOUSE" 'libinput Middle Emulation Enabled' 1
##xinput --set-prop "$MOUSE" 'libinput Button Scrolling Button' 9

xinput --set-prop "$MOUSE" 'libinput Scroll Method Enabled' 0 0 1
xinput --set-prop "$MOUSE" 'libinput Button Scrolling Button' 9

# map button 8 to button 2
xinput set-button-map "$MOUSE" 1 2 3 4 5 6 7 2 9 10 11 12 13 14 15 16
