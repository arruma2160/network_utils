#! /bin/bash

#   @usage:     get_netmask <network interface>
#   @arg:       <network_interface> e.g eth0, wlan0, lo
#   @example:   get_netmask eth0
#   @return:    error -> 1
get_netmask () {
    
    ## Verifying passing of one argument - just considering the first argument
    if [ ! "$1" ]; then
        echo "[ *] Error - 'get_netmask' usage: "
        echo -e "\tget_netmask <network_interface>"
        return 1
    fi
    
    ## Verifying interface passed exists
    OUTPUT_IFC=$(ifconfig $1 2> /dev/null)
    if [ ! "${OUTPUT_IFC}" ]; then
        echo "[ *] Error - interface '$1' seems not to be present on the system"
        return 1
    fi
}
    
## Testing
get_netmask eth1
