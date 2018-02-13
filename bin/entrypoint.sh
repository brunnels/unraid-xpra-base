#!/bin/sh

userdel -r nobody > /dev/null 2>&1

_passwd=`getent passwd $PUSER`
if [ "$_passwd" != "" ]; then
    PUID=`echo $_passwd | cut -d: -f 3`
    PGID=`echo $_passwd | cut -d: -f4`
    PGROUP=`getent group $PGID | cut -d: -f 1`
    HOME=`echo $_passwd | cut -d: -f 6`
else
    _group=`getent group $PGROUP`
    if [ "$_group" != "" ]; then
        PGID=`echo $_group | cut -d: -f 3`
    else
        groupadd -g $PGID $PGROUP
    fi
    HOME=${PUSER_HOME:-/home/$PUSER}
    useradd -u $PUID -g $PGID -G xpra -d $HOME -om -s /bin/bash $PUSER
    mkdir -m 700 -p /var/run/user/$PUID
    chown $PUID:$PGID $HOME /var/run/user/$PUID
    for _skel in /etc/skel/.*; do
        _file=`basename $_skel`
        [ "$_file" != . -a "$_file" != .. ] && /usr/sbin/gosu $PUSER cp -p /etc/skel/$_file $HOME
    done
fi

usermod -a -G lpadmin $PUSER

rm -f /tmp/.X100-lock

/docker/preexecAsRoot

_args=
for _arg in "$@"; do
    [ "$_args" != '' ] && _args=$_args' '
    _args=$_args`echo $_arg | sed -r -e 's/(['\'\"\\\`' \t\n\$&|;<>%!#\\\\(){}[]|])/\\\\\1/g'`
done

/usr/sbin/gosu $PUSER pulseaudio --start > /dev/null 2>&1

exec /usr/sbin/gosu ${PUSER} /usr/bin/xpra start ${DISPLAY}\
  --no-daemon\
  --mdns=no\
  --webcam=no\
  --tcp-auth=env\
  --html="${XPRA_HTML}"\
  --bind-tcp="0.0.0.0:${XPRA_TCP_PORT}"\
  ${XPRA_OPTIONS}\
  --start-child="$_args"\
