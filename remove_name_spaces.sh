#! /bin/bash
# 
#
# 


##----------------------------------------
# Substitute spaces in string " " for underscores "_"
# usage:  subs_spaces <string>
# return: string with no spaces
# example: subs_spaces 'name of file' -> name_of_file

function subs_spaces() 
{
    echo $(echo "$@" | tr " " "_")
}


##----------------------------------------
# Recursively from directory, executes a the function 
# passed as argument on archive name.
# usage: perform_recursive_action <directory> <function>
# return: nothing
# example: perform_recursive_action . echo

function perform_recursive_action() 
{
    ## Good use of function checks
    if [ $# != 2 ] && [ ! -d "$1" ] ; then
        printf "perform_recursive_action <directory>"
    ## main functionality
    else
        FROM=$(pwd)
        ## change argument folder if needed
        aux=$(eval "$2" "$1")
        if [ "${aux}" != "$1" ]; then 
            mv "$1/" "${aux}/"
        fi
        ## Continue and recurse
        cd "${aux}"
        ls | while read archive; do
            if [ -d "${archive}" ]; then
                aux=$(eval "$2" "${archive}")
                if [ "${aux}" != "${archive}" ]; then 
                    mv "${archive}/" "${aux}/"
                fi
                perform_recursive_action ${archive} $2
            else
                aux=$(eval $2 "${archive}")
                if [ "${aux}" != "${archive}" ]; then 
                    mv "${archive}" "${aux}"
                fi
            fi
        done
        cd ${FROM}
    fi
}


##----------------------------------------
##----------------------------------------
# Script testing
#

function test_case() 
{
    if [ "$2" != "$3" ]; then
        ## Error
        echo "0"
    else
        ## Correct
        echo "1"
    fi
}
 
function test_print_result() 
{
    printf "[%d] Test: " "$1"
    if [ "$2" == "1" ]; then
        printf "passed -> $3 != $4 \n"
    elif [ "$2" == "0" ]; then
        printf "Error at _%d_: $3 != $4 \n" \
            "${test_number}"
    fi
}


function self_tests() 
{
    tests_passed=0


    ## -----------------------------------
    test_number=1
    subs=$(subs_spaces "name with spaces")
    expected="name_with_spaces"
    rc=$(test_case ${test_number} ${subs} ${expected})
    test_print_result "${test_number}" "${rc}" "${subs}" "${expected}"
    tests_passed=$((${tests_passed} + ${rc}))


    ## -----------------------------------
    test_number=2
    subs=$(subs_spaces " space at beginning")
    expected="_space_at_beginning"
    rc=$(test_case ${test_number} ${subs} ${expected})
    test_print_result "${test_number}" "${rc}" "${subs}" "${expected}"
    tests_passed=$((${tests_passed} + ${rc}))


    ## -----------------------------------
    test_number=3
    subs=$(subs_spaces "space at end of name ")
    expected="space_at_end_of_name_"
    rc=$(test_case ${test_number} ${subs} ${expected})
    test_print_result "${test_number}" "${rc}" "${subs}" "${expected}"
    tests_passed=$((${tests_passed} + ${rc}))


    ## -----------------------------------
    test_number=4
    subs=$(subs_spaces " space at start and end ")
    expected="_space_at_start_and_end_"
    rc=$(test_case ${test_number} ${subs} ${expected})
    test_print_result "${test_number}" "${rc}" "${subs}" "${expected}"
    tests_passed=$((${tests_passed} + ${rc}))


    ## -----------------------------------
    test_number=5
    expected="perform_recursive_action <directory>"
    result="$(perform_recursive_action)"
    rc=$(test_case "${test_number}" "${result}" "${expected}")
    test_print_result "${test_number}" "${rc}" "${result}" "${expected}"
    tests_passed=$((${tests_passed} + ${rc}))


    ## -----------------------------------
    test_number=6
    mkdir -p temporal && cd temporal && touch "uno dos tres"
    mkdir -p temp1 && cd temp1 && touch "cuatro cinco seis"
    cd .. && mkdir -p temp2 && cd temp2 && touch "siete ocho nueve"
    cd ../..
    perform_recursive_action "temporal" subs_spaces
    if [ -e "./temporal/uno_dos_tres" ] && \
    [ -e "./temporal/temp1/cuatro_cinco_seis" ] && \
    [ -e "./temporal/temp2/siete_ocho_nueve" ]; then
        rc=1
    else
        rc=0
    fi
    if [ "${rc}" == 0 ]; then
        printf "Error at _%d\n" ${test_number}
    else
        printf "[%d] Test: passed -> %s\n" ${test_number} "corrected spaces at tree of folders"
        tests_passed=$((${tests_passed} + ${rc}))
    fi
    rm -rf temporal


    ## -----------------------------------
    test_number=7
    mkdir "test 7"
    cd "test 7"
    touch "uno" "dos" "tres" "cuatro cinco"
    cd ..
    perform_recursive_action "test 7" subs_spaces
    if [ -e "test_7" ] && [ -e "test_7/cuatro_cinco" ]; then
        rc=1
    else
        rc=0
    fi
    if [ "${rc}" == 0 ]; then
        printf "Error at _%d\n" ${test_number}
    else
        printf "[%d] Test: passed -> %s\n" ${test_number} "corrected spaces at folder argument"
        tests_passed=$((${tests_passed} + ${rc}))
    fi
    rm -rf "test_7"


    ## Final banner -> results
    printf "\nResult: %d/%d tests passed\n" "${tests_passed}" "${test_number}"
    if [ "${test_number}" != "${tests_passed}" ]; then
        printf "[!!] Errors detected at self_tests function\n"
    fi
}

#####-----------------------
# Main functionality

self_tests
#perform_recursive_action $1 echo
