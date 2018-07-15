#! /bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for i in /etc/X11/xinit/xinitrc.d/* ; do
  if [ -x "$i" ]; then
    . "$i"
  fi
  done
fi

PRIMARY_MONITOR="$(xrandr --query | grep ' connected primary' | cut -d' ' -f1 | head -n1)"
SECONDARY_MONITOR="$(xrandr --query | grep ' connected' | grep -v ' primary' | cut -d' ' -f1 | head -n1)"

echo "i3.mon.primary: $PRIMARY_MONITOR" > $HOME/.Xi3config

if [ -n "$SECONDARY_MONITOR" ]; then
  echo "i3.mon.secondary: $SECONDARY_MONITOR" >> $HOME/.Xi3config
fi

[ -f /etc/xprofile ] && . /etc/xprofile
[ -f $HOME/.xprofile ] && . $HOME/.xprofile
[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources
[ -f $HOME/.xsession ] && . $HOME/.xsession

if [ "$XDG_VTNR" -eq 2 ]; then
  exec startxfce4
else
  [ -f $HOME/.Xi3config ] && xrdb -merge $HOME/.Xi3config
  export XDG_CURRENT_DESKTOP=i3
  export XDG_SESSION_DESKTOP=i3
  exec dbus-launch --exit-with-session lxsession -s i3
fi
