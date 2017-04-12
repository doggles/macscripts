#!/bin/sh
#
# MAC UPTIME
# github.com/geoffrepoli
#
# to use as a replacement for `uptime`
# 1. `uptime` command in macOS seems to be broken in 10.12.x, often incorrect total uptime
# 2. `uptime` stdout was not written with text extraction in mind
# This script uses the `kern.boottime` oid to pull the epoch timestamp that is made when the mac starts up
# Then, it subtracts the boot timestamp from the current time in epoch time to get the uptime in epoch time
# Finally, we convert epoch time to years, weeks, days, hours, minutes, seconds to be human readable 

convert_secs() {
  local T="$1"
  local Y=$((T/60/60/24/365))
  local W=$((T/60/60/24/7%52))
  local D=$((T/60/60/24%7))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  [[ $Y > 0 ]] && printf '%dy ' $Y             
  [[ $W > 0 ]] && printf '%dw ' $W
  [[ $D > 0 ]] && printf '%dd ' $D
  [[ $H > 0 ]] && printf '%dh ' $H
  [[ $M > 0 ]] && printf '%dm ' $M
  [[ $D > 0 || $H > 0 || $M > 0 ]] && printf '%ds\n' $S
}

# get last bootup timestamp
boottime=$(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')

# get current epoch time
epoch=$(date +%s)

# convert difference from epoch - boottime into readable format
mac_uptime=$(convert_secs "$(( $epoch - $boottime ))")

echo "<result>$mac_uptime</result>"