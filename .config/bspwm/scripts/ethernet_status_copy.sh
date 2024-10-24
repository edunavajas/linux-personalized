#!/bin/sh 
 
/usr/sbin/ifconfig ens37 | grep "inet " | awk '{print $2}' | tr -d '\n' | xclip -selection clipboard  