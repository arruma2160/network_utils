#! /bin/bash
# Script to check what machines are reachable with a simple ping in your network

while true; do 
    echo "--------------------------" 
    date 
    echo
    for pc in `seq 1 254`; do   
        PC=$(ping -c 1 192.168.0.$pc | grep "Unreachable")
        if [ ! "$PC" ]; then  
            echo "192.168.0.$pc is alive"
        fi
    done
done
