#!/bin/bash -norc
#
# last updated 02 May 2009, 22:57:27 trinity
#
# This is Trinity's cool xsession/xinitrc file.  This functions as both
# files, so pay attention.

# Make sure the $HOME env var is set
if [ "x$HOME" = "x" ] ; then
  HOME=/home/trinity
  export HOME
fi

if [ $0 == "$HOME/.xsession" ] ; then
  # Inform everybody that we're starting up
  /usr/bin/aplay --quiet ${HOME}/media/snd/wav/startup.wav
  # Set a few environment variables here, since .profile will not be
  # processed in a non-interactive shell.
  KDE_DIR=/usr
  if [ "x$LD_LIBRARY_PATH" != "x" ] ; then
    LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
  else
    LD_LIBRARY_PATH=$HOME/lib
  fi
  PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/games:/usr/games:$HOME/bin
  QTDIR=/usr
  TRNINIT="-B -i=24 -f -N -x6lms -X5Z+ -d$HOME/news -z0 -hX-Cache"
  TZ=CST6CDT
  XENVIRONMENT=$HOME/Xdefaults
  export KDE_DIR LD_LIBRARY_PATH PATH QTDIR TRNINIT TZ XENVIRONMENT
else
  REVERSE='-rv'
fi

# See how many heads we've got to deal with
if [ `/usr/bin/xdpyinfo | awk '/number of screens/{print $4}'` == "2" ] ; then
  SECONDDISPLAY="-display :0.1"
fi

# Set up the font paths so we get all our cool fonts.
. $HOME/share/fonts/font-setup

# Set the root window to something cool-looking.
$HOME/bin/gen-random-list.pl $HOME/pics/bgnds/fullsize > $HOME/.bgpiclist
/usr/bin/xv -display :0.0 +cmap -root -maxpect -rmode 5 -smooth -flist $HOME/.bgpiclist -wait 600 -wloop &
if [ "x$SECONDDISPLAY" != "x" ] ; then
  /usr/bin/xv $SECONDDISPLAY +cmap -root -maxpect -rmode 5 -smooth -flist $HOME/.bgpiclist -wait 600 -wloop &
fi

# Remap right-alt to be compose (altgr, maybe?), and the win-don't
# keys to super (the window) and hyper (the menu).  No win-don't
# keyboard on limbo, so we don't run this there.
if [ "x$HOSTNAME" != "xlimbo" ] ; then
  /usr/bin/xmodmap $HOME/Xmodmap
fi

# Load up some programs that are nice to have on the desktop
/usr/bin/xscreensaver -no-splash &
/usr/bin/xmmix $SECONDDISPLAY -geometry +0-0 -iconic -autoload $HOME/.xmmix.mxr &
/usr/bin/oclock $SECONDDISPLAY -fg red3 -bd grey40 -transparent -geometry -5-5 &
/usr/bin/xterm $SECONDDISPLAY $REVERSE -fn 7x14 -geometry +0-0 -T Alpine -e alpine -d 0 &
if [ "x$HOSTNAME" == "xlimbo" ] ; then
  $HOME/bin/xpostit2 -geometry +0-0 &
  #/usr/bin/synergys
fi

# Now for the window manager
/usr/bin/fvwm
#/usr/bin/compiz --replace ccp

# Now terminate the programs we don't need to run anymore.
/usr/bin/killall artsd
/usr/bin/killall gconfd-2
/usr/bin/killall xscreensaver
/usr/bin/killall synergys
/usr/bin/killall xv
/bin/rm -f $HOME/.bgpiclist
# When we're the .xsession file, it's not a login shell, and so will not
# process the .bash_logout.  We'll just run it here, so we don't have a
# bunch of repeated stuff.
if [ $0 == "$HOME/.xsession" ] ; then
  . $HOME/.bash_logout
fi
