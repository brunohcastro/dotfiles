#! /bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for i in /etc/X11/xinit/xinitrc.d/* ; do
  if [ -x "$i" ]; then
    . "$i"
  fi
  done
fi

[ -f /etc/xprofile ] && . /etc/xprofile
[ -f $HOME/.xprofile ] && . $HOME/.xprofile
[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources
[ -f $HOME/.xsession ] && . $HOME/.xsession

export XDG_CURRENT_DESKTOP=i3
export XDG_DESKTOP_SESSION=i3

exec i3
