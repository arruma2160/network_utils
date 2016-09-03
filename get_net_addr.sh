#! /bin/bash

#   @usage:     get_netmask <network interface>
#   @arg:       <network_interface> e.g eth0, wlan0, lo
#   @example:   get_netmask eth0
#   @return:    error -> 1
#               success -> string:network mask address of selected interface
get_netmask () {
    
    ## Verifying passing of one argument - just considering the first argument
    if [ ! "$1" ]; then
        ( >&2 echo "[ *] Error - 'get_netmask' usage: " )
        ( >&2 echo -e "\tget_netmask <network_interface>")
        return 1
    fi
    
    ## Verifying interface passed exists
    local OUTPUT_IFC=$(ifconfig $1 2> /dev/null)
    if [ ! "${OUTPUT_IFC}" ]; then
        ( >&2 echo "[ *] Error - interface '$1' seems not to be present on the system" )
        return 1
    fi

    ## At this point OUPUT_IFC contains the info from ifconfig for the network interface resquested
    local NETMASK_ADDR=$(echo ${OUTPUT_IFC} | \
                 egrep -o 'Mask:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | \
                 cut -d: -f2 )
    if [ ! "${NETMASK_ADDR}" ]; then
        ( >&2 echo "[ *] No mask_addr" )
        return 1
    else    
        echo ${NETMASK_ADDR}
    fi
}
    
#   @usage:     get_ip_addr <network interface>
#   @arg:       <network_interface> e.g eth0, wlan0, lo
#   @example:   get_ip_addr eth0
#   @return:    error -> 1
#               success -> string:network ip address of selected interface
get_ip_addr () {
    
    ## Verifying passing of one argument - just considering the first argument
    if [ ! "$1" ]; then
        ( >&2 echo "[ *] Error - 'get_ip_addr' usage: " )
        ( >&2 echo -e "\tget_ip_addr <network_interface>")
        return 1
    fi
    
    ## Verifying interface passed exists
    local OUTPUT_IFC=$(ifconfig $1 2> /dev/null)
    if [ ! "${OUTPUT_IFC}" ]; then
        ( >&2 echo "[ *] Error - interface '$1' seems not to be present on the system" )
        return 1
    fi

    ## At this point OUPUT_IFC contains the info from ifconfig for the network interface resquested
    local IP_ADDR=$(echo ${OUTPUT_IFC} | \
                 egrep -o 'inet addr:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | \
                 cut -d: -f2 )
    if [ ! "${IP_ADDR}" ]; then
        ( >&2 echo "[ *] No ip address" )
        return 1
    else    
        echo ${IP_ADDR}
    fi
}
## Testing
get_netmask 
get_netmask eth0
get_netmask wlan0
echo "-------------"
get_ip_addr
get_ip_addr eth0
get_ip_addr wlan0
