#! /bin/bash
# Get interface information about a particular interface
# Check log file for errors or debug info and info file for parameters

LOG_FILE="network_parameters.log"
INFO_FILE="network_parameters.info"

# remove previous log file
if [ -f "$LOG_FILE" ]; then
    rm $LOG_FILE
    touch $LOG_FILE
fi

# Check for a particular interface
if [ ! $# -eq 1 ]; then
    if [ $# -eq 0 ]; then echo "No arguments found" >> $LOG_FILE ; fi
    echo "usage: ./network_parameters.sh <interface>" >> $LOG_FILE 
    UP_INTERFACE=$(ip link show | grep "state UP" | cut -d: -f2- | cut -d" " -f2 | cut -d: -f1)
    echo "sugestion of interface (UP): $UP_INTERFACE" >> $LOG_FILE
    exit 1
fi

## check for tools availability in the system, otherwise abort banner display
## sh is used by popen
ip_loc=$(which ip)

if [ ! -z "$ip_loc" ]; then
    ## ip utility exists --
    echo "$(date):  ip command line tool present in the system " >> $LOG_FILE

    ## gather interfaces names -- 
    NAMES=($(ip -o -f inet addr show | grep -v " lo " | cut -d" " -f2))
    ## debug names buffer
    echo "[DEBUG ] names: ${NAMES[@]}" >> $LOG_FILE

    ## gather interfaces ipv4 addresses
    IPV4_ADD=($(ip -o -f inet addr show | grep -v " lo " | cut -d" " -f7 | cut -d/ -f1))
    ## debug ipv4 addresses buffer
    echo "[DEBUG ] ipv4: ${IPV4_ADD[@]}" >> $LOG_FILE

    ## gather broadcast addresses
    IPV4_BROADCAST_ADD=($(ip -o -f inet addr show | grep -v " lo " | cut -d" " -f9))
    ## debug ipv4 broadcast addresses
    echo "[DEBUG ] broadcast ipv4: ${IPV4_BROADCAST_ADD[@]}">> $LOG_FILE

    ## gather hardware addresses
    HDR_ADD=($(ip -o -f link addr show | grep -v " lo:" | cut -d" " -f18))
    ## debug hardware addresses
    echo "[DEBUG ] hardware: ${HDR_ADD[@]}" >> $LOG_FILE

    ## gather hardware broadcast addresses
    HDR_BRD_ADD=($(ip -o -f link addr show | grep -v " lo:" | cut -d" " -f20))
    ## debug hardware broadcast addresses
    echo "[DEBUG ] broadcast hardware: ${HDR_BRD_ADD[@]}" >> $LOG_FILE

else
    ## ip command line tool doesn't exist --
    echo "Abort"
    exit 1
fi
    
index=0
for name in ${NAMES[@]}; do
    if [ "$1" == "$name" ]; then
        break
    else 
        index=$((i + 1))
    fi
done

if [ $index -gt ${#NAMES[@]} ]; then
    echo "[DEBUG ] - Name not found " >> LOG_FILE
    exit 1
else
    echo "name:     ${NAMES[$index]}"
    echo "ipv4:     ${IPV4_ADD[$index]}"
    echo "ipv4 bdr: ${IPV4_BROADCAST_ADD[$index]}"
    echo "hdr addr: ${HDR_ADD[$index]}"
    echo "hdr bdr:  ${HDR_BRD_ADD[$index]}"
fi

exit 0


