#! /bin/bash
# Script to check what machines are reachable with a simple ping in your network
# TODO: Read host IP address, calculate with network address possible IP addresses
# of other network devices. Run then the ping loop on all of these address.

function usage() {
    echo "./lan_controller.sh"
    echo "network of type: 192.168.0.0"
}

function main() {
    while true; do 
        echo "--------------------------" 
        echo "Starting new scanning at : $(date)"
        echo
        for pc in `seq 1 254`; do   
            PC=$(ping -c 1 192.168.0.$pc | grep "Unreachable")
            if [ ! "$PC" ]; then  
                echo "192.168.0.$pc is alive"
            fi
        done
    done
}

# Starting program
case "$1" in
    "help") usage;;
    *) main;;
esac

