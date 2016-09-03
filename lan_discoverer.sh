#! /bin/bash

#   @usage:     get_netmask <network interface>
#   @arg:       <network_interface> e.g eth0, wlan0, lo
#   @example:   get_netmask eth0
get_netmask () {
    if [ ! "$1" ]; then
        echo "[ *] Error - 'get_netmask' usage: "
        echo -e "\tget_netmask <network_interface>"
        return 1
    fi
}
    
## Testing
get_netmask
