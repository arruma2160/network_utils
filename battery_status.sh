#! /bin/bash

ACPI=$(acpi)

function test_acpi_dependencies() {
    if [ ! "$(which acpi)" ]; then
        echo ""
        echo "[*] $0: wants to install acpi dependencies"
        echo ""
        sudo apt-get install acpi
    fi
}

function main_functionality() {
    if [ "$(echo $ACPI | grep Discharging)" ]; then
        REMAINING_PERCENT=$(echo $ACPI | cut -d, -f2)
        REMAINING_TIME=$(echo $ACPI | cut -d, -f3 | cut -d" " -f2)
        echo " Battery:   $REMAINING_PERCENT"
        echo " Time left:  $REMAINING_TIME"
    elif [ "$(echo $ACPI | grep Charging)" ]; then
        echo " Charging"
    elif [ "$(echo $ACPI | grep Full)" ]; then
        echo " Charged"
    fi
}


## Main
test_acpi_dependencies
main_functionality
