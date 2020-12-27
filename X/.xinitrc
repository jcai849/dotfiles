#!/bin/sh

intern='eDP-1'
extern='^(HDMI-1|DP-1)'

if  (xrandr | grep '^HDMI-1 connected'); then
	xrandr --output 'eDP-1' --off --output 'HDMI-1' --auto
elif (xrandr | grep '^DP-1 connected'); then
	xrandr --output 'eDP-1' --off --output 'DP-1' --auto
fi

xrdb ~/.Xresources
# autocutsel &
exec bspwm
