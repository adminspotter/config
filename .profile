# Make sure we have a valid $HOME env var
if [ "x$HOME" = "x" ] ; then
  #HOME=/home/trinity
  HOME=/Users/tquirk
  export HOME
fi

# Just in case...
if [ -z $TERM ] ; then
  TERM=console
  export TERM
fi

# Give a nice greeting if we're on the console
#if [ "x$SSH_CONNECTION" = "x" -a $TERM != "xterm" ] ; then
#  /usr/bin/aplay --quiet /media/trinity/snd/wav/startup.wav
#fi

umask 022
set -o notify
#eval `dircolors -b`

# Set up the environment
KDE_DIR=/usr
LANG=en_US.UTF-8
LC_COLLATE=C
LC_CTYPE=en_US.UTF-8
if [ "x$LD_LIBRARY_PATH" != "x" ] ; then
  LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
else
  LD_LIBRARY_PATH=$HOME/lib
fi
LESS="-MMs"
LESSCHARSET=utf-8
LESSHISTFILE="-"
LS_COLORS="$LS_COLORS*.tga=01;35;"
#LS_OPTIONS="-bFT 0 --color=auto"
LS_OPTIONS="-bF"
MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man:/usr/man:$HOME/share/man
NNTPSERVER=news.ymb.net
NO_ORIGINATOR=yes
#PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/games:/usr/games:$HOME/bin
PATH=${PATH}:${HOME}/bin
PS1='\h:\w\$ '
#QTDIR=/usr
TRNINIT="-B -i=24 -f -N -x6lms -X5Z+ -d$HOME/news -z0 -hX-Cache"
TZ=CST6CDT
#WWW_HOME=http://www.io.com/~wwagner/
XENVIRONMENT=$HOME/.Xdefaults
#XMCD_LIBDIR=/usr/lib/X11/xmcd

if [ $TERM != "xterm" ] ; then
  EDITOR=vi
  VISUAL=vi
else
  EDITOR="emacs -r"
  PROMPT_COMMAND='echo -n "]2;$USER  $HOSTNAME:$PWD]1;$HOSTNAME"'
  VISUAL=vi
  XAPPLRESDIR=$HOME/lib/X11/app-defaults
fi

export EDITOR KDE_DIR LANG LC_COLLATE LD_LIBRARY_PATH LESS LESSCHARSET LESSHISTFILE LS_COLORS LS_OPTIONS MANPATH NNTPSERVER NO_ORIGINATOR PATH PROMPT_COMMAND PS1 QTDIR TRNINIT TZ VISUAL WWW_HOME XAPPLRESDIR XENVIRONMENT XMCD_LIBDIR

if [ -f ~/.bashrc ] ; then
  . ~/.bashrc
fi
