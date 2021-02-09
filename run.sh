#!/usr/bin/env bash

export DISPLAY=:0

# Audio loopback device
pulseaudio -D --exit-idle-time=-1 --system --disallow-exit --log-level=0
pactl load-module module-null-sink sink_name=DummyOutput sink_properties=device.description="Speakers"

# Start Xvfb
Xvfb -screen 0, 1920x1080x24 &
while [ ! -e /tmp/.X11-unix/X0 ]; do sleep 1; done

# Run blackbox + VNC
blackbox &
x11vnc -nopw -noncache -forever -q -bg

# Start Chrome, exit container when quitting
wine Chrome-bin/chrome.exe --disable-gpu --start-maximized # add more startup flags here