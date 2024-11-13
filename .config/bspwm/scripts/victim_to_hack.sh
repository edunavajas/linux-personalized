#!/bin/bash
 
ip_address=$(/bin/cat /home/$(logname)/.config/bin/target | awk '{print $1}')
machine_name=$(/bin/cat /home/$(logname)/.config/bin/target | awk '{print $2}')
 
if [ $ip_address ] && [ $machine_name ]; then
    echo "%{F#e51d0b}󰓾 %{F#ffffff}$ip_address%{u-} - $machine_name"
else
    echo "%{F#e51d0b}󰓾 %{u-}%{F#ffffff} No target"
fi


mkdir /home/$(logname)/.config/bin
touch /home/$(logname)/.config/bin/target

nano /home/$(logname)/.zshrc


# Custom functions

function settarget(){
    ip_address=$1
    machine_name=$2
    echo "$ip_address $machine_name" > /home/$(logname)/.config/bin/target
}

function cleartarget(){
    echo '' > /home/$(logname)/.config/bin/target
}
