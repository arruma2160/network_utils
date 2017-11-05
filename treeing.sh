#! /bin/bash
#
#   Script emulating 'tree' tool   
#   Usage: ./treeing.sh <dir_to_start_treeing>
#

LEVEL=0

#   usage: tabuling <number_of_tabs>
#   Desc.: Includes a <number_of_tabs> before the sucessive 'echo'
#
tabuling() {
    if [ ! $# -eq 1 ]; then 
        echo "[DEBUG - ] Error in usage of this function"
        echo "[DEBUG - ] usage: tabuling <number_of_tabs>"
    else
        for i in `seq 1 $1`; do
            echo -ne "\t"
        done
    fi
}

#   usage: display_tree <level>
#   Desc.: function that works out the tree display
#
display_tree()
{
    local LEVEL_LOCAL=$1
    ls | while read FILE ; do 
        if [ -d "$FILE" ]; then
            tabuling "$LEVEL_LOCAL"
            echo "${FILE}/"
            tabuling "$LEVEL_LOCAL"
            echo "================================="
            cd "$FILE"
            display_tree $(( LEVEL_LOCAL + 1 ))
            cd ..
            echo 
        else
            tabuling "$LEVEL_LOCAL"
            echo "$FILE"
        fi
        sleep 0.5 ## can be removed - it is only to slow down a bit the screen
    done
}

#   usage: main $1 
#   args:   $1 ->   argument provided from command line and 
#                   that now it should be passed to main function

main() {

    if [ ! $# -eq 1 ]; then
        ## Verification of parameters for script
        echo "[* Error - ] Provide argument: directory to start treeing - "
        echo "[* Info  - ] usage: ./treeing.sh <directory_to_start_treeing> -"
        exit 1
    fi

    DIR_TO_RETURN_TO=$(pwd)
    cd $1 2> /dev/null

    if [ ! $? ]; then
        ## Error moving into directory
        echo "[* Error - ] Directory provided as argument error - verify: $1"
        if [ "$(pwd)" != "$DIR_TO_RETURN_TO" ]; then
            cd $DIR_TO_RETURN_TO
        fi
        exit 1
    else
        ## Start treeing at specified directory 
        display_tree $LEVEL
        cd $DIR_TO_RETURN_TO
    fi
}

## M A I N ##
main $1
exit 0
