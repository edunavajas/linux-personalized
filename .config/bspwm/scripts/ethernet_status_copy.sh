#!/bin/sh

if /usr/sbin/ifconfig ens37 >/dev/null 2>&1; then
    interface="ens37"
    elif /usr/sbin/ifconfig ens33 >/dev/null 2>&1; then
    interface="ens33"
else
    interface="ens37"
fi

/usr/sbin/ifconfig $interface | grep "inet " | awk '{print $2}' | tr -d '\n' | xclip -selection clipboard