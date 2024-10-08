#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pidof polybar >/dev/null; do sleep 1; done

TRAY_POS=right MONITOR=DisplayPort-1 polybar default &
MONITOR=DisplayPort-0 polybar default &
# # TRAY_POS=right MONITOR=$(polybar -m | awk -F: '{print $1}') polybar default &
#
# for i in $(polybar -m | grep -v primary | awk -F: '{print $1}'); do MONITOR=$i polybar default &; done
