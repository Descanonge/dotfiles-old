#!/bin/sh

setxkbmap -print | sed -e '/xkb_keycodes/s/"[[:space:]]/+int&/' | xkbcomp -I${HOME}/.xkb - $DISPLAY
