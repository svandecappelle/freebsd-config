#!/bin/bash

compton &
feh --bg-scale ~/.config/wall.jpg

RESET="\x01"
RED="\x05"
YELLOW="\x04"
GREEN="\x03"

function icon() {
   echo `printf "%b" "\\u$1"`
}

avg_load() {
    #AVG_LOAD=`uptime | awk -F'load averages:' '{ print $2 }'`
    AVG_LOAD=`uptime | awk -F'[a-z]:' '{ print $2 }'`
    echo "L:$AVG_LOAD"
}

dte() {
    echo $(date)
}

battery() {

    CAPACITY=`acpiconf -i 0 | grep 'Remaining capacity:' | cut -f2`
    TIME=`acpiconf -i 0 | grep 'Remaining time:' | cut -f3`
    STATE=`acpiconf -i 0 | grep 'State:' | cut -f4`
    ICON=$(icon "f240")

    if [ $STATE == "discharging" ]; then
        STATE="-"
    elif [ $STATE == "charging" ]; then
        STATE="+"
    fi

    if [ $STATE == "-" ]; then
        echo "$ICON: $CAPACITY [$STATE] ($TIME)"
    elif [ $STATE == "+" ]; then
        echo "$ICON: $CAPACITY [$STATE]" 
    fi
}

brand() {
    BRAND=$'\uf30c'
    echo $BRAND
}

cpu (){
        _cpu=$(vmstat | awk 'NR==3 {print $(NF-2)}')     # See man vmstat(1)
	_cpuicon=$(icon "f986")
        
        if test "$_cpu" -ge 70; then
		COLOR=$RED
        elif test "$_cpu" -ge 50; then
		COLOR=$YELLOW
        else
		COLOR=$GREEN
        fi
 	echo -e "$COLOR$_cpuicon $_cpu%$RESET"
}

cpu_temp (){
        _temp=$(sysctl dev.cpu.0.temperature | sed -e 's|.*: \([0-9]*\).*|\1|')  # See man sysctl(1)
	_tempicon=$(icon "f2c9")
        
        if test "$_temp" -ge 70; then
		COLOR=$RED
        elif test "$_temp" -ge 50; then
		COLOR=$YELLOW
        elif test "$_temp" -ge 1; then
		COLOR=$GREEN
        fi
	echo -e "$COLOR$_tempicon $_temp°$RESET"
}

memory (){
	_memory=$(free | awk '(NR == 18){ sub(/%$/,"",$6); print $6; }' | tr -d '%]')      # free is a perl script to show free ram on FreeBSD.
	_memoryicon=$(icon "f85a")
       
	if test "$_memory" -ge 80; then
		COLOR=$RED
        elif test "$_memory" -ge 50; then
		COLOR=$YELLOW
        elif test "$_memory" -ge 1; then
		COLOR=$GREEN
        fi
	echo -e "$COLOR$_memoryicon $_memory%$RESET"
}

wifi (){
#       ifconfig wlan0 | grep ssid | cut -w -f 3        # Print wireless SSID name.
        _wifiperc=$(ifconfig wlan0 | grep txpower | cut -w -f 3)     # Print wireless SSID signal strength - see ifconfig(1).
        if test "$_wifiperc" -ge 90; then
                _wifiicon=$(icon "faa8")
        elif test "$_wifiperc" -ge 70; then
                _wifiicon=$(icon "faa8")
        elif test "$_wifiperc" -ge 1; then
                _wifiicon=$(icon "faa8")
        else
                _wifiicon=$(icon "faa9")
        fi

        if test "$_wifiperc" -ge 90; then
                echo "$_wifiicon" "$_wifiperc"% "$DELIM"
        elif test "$_wifiperc" -ge 70; then
                echo "$_wifiicon" "$_wifiperc"% "$DELIM"
        elif test "$_wifiperc" -ge 1; then
                echo "$_wifiicon" "$_wifiperc"% "$DELIM"
        else
                echo "$_wifiicon" "$DELIM"
        fi
}

while true; do
	xsetroot -name  "$(cpu) $(cpu_temp) $(memory) | $(battery) | $(dte) | $(brand)"
    sleep 1
done &
