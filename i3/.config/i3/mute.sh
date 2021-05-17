#!/bin/sh
if [ $(amixer get Master | tail -2 | grep -c '\[on\]') = 0 ]; then
	amixer -D pulse sset Master unmute
else
	amixer -D pulse sset Master mute
fi
