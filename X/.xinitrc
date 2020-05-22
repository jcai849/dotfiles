#!/bin/sh

intern='eDP-1'
extern='(HDMI-1|DP-1)'

if xrandr | egrep "${extern} connected"; then
    xrandr --output "${intern}" --off --output "${extern}" --auto
else
    xrandr --output "${extern}" --off --output "${intern}" --auto
fi

xrdb ~/.Xresources
xsetroot -cursor_name X_cursor
autocutsel &
exec bspwm
