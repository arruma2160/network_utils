#! /bin/bash
# Script to check what machines are reachable with a simple ping in your network
function usage() {
    echo "./lan_controller.sh"
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
main
