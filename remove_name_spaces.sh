#! /bin/bash
# 
#
# 


##----------------------------------------
# Substitute spaces in string " " for underscores "_"
# usage:  subs_spaces <string>
# return: string with no spaces
# example: subs_spaces 'name of file' -> name_of_file

function subs_spaces() {
    echo $(echo "$@" | tr " " "_")
}


##----------------------------------------
# Recursively from directory, executes a the function 
# passed as argument on archive name.
# usage: all_archives_in_dir <directory> <function>
# return: nothing
# example: all_archives_in_dir . echo

function all_archives_in_dir() {
    if [ $# != 2 ]; then
        printf "all_archives_in_dir <directory>\n"
    fi
    if [ ! -d "$1" ]; then
        printf "Argument not a directory\n"
    fi
    FROM=$(pwd)
    cd $1
    ls | while read archive; do
        if [ -d "${archive}" ]; then
            aux=$(eval $2 "${archive}")
            if [ "${aux}" != "${archive}" ]; then 
                mv "${archive}/" "${aux}/"
            fi
            all_archives_in_dir ${archive} $2
        else
            aux=$(eval $2 "${archive}")
            if [ "${aux}" != "${archive}" ]; then 
                mv "${archive}" "${aux}"
            fi
        fi
    done
    cd ${FROM}
}


##----------------------------------------
##----------------------------------------
# Script testing
#

function test_case() {
    if [ "$2" != "$3" ]; then
        echo "0"
    else
        echo "1"
    fi
}
 
function test_print_result() {
    printf "[%d] Test: " "$1"
    if [ "$2" == "1" ]; then
        printf "passed -> $3 != $4 \n"
    elif [ "$2" == "0" ]; then
        printf "Error at _%d_: $3 != $4 \n" \
            "${test_number}"
    fi
}


function self_tests() {
    tests_passed=0

    test_number=1
    subs=$(subs_spaces "name with spaces")
    expected="name_with_spaces"
    rc=$(test_case ${test_number} ${subs} ${expected})
    test_print_result ${test_number} ${rc} ${subs} ${expected}
    tests_passed=$((${tests_passed} + ${rc}))

    test_number=2
    subs=$(subs_spaces " space at beginning")
    expected="_space_at_beginning"
    rc=$(test_case ${test_number} ${subs} ${expected})
    test_print_result ${test_number} ${rc} ${subs} ${expected}
    tests_passed=$((${tests_passed} + ${rc}))

    test_number=3
    subs=$(subs_spaces "space at end of name ")
    expected="space_at_end_of_name_"
    rc=$(test_case ${test_number} ${subs} ${expected})
    test_print_result ${test_number} ${rc} ${subs} ${expected}
    tests_passed=$((${tests_passed} + ${rc}))


    test_number=4
    subs=$(subs_spaces " space at start and end ")
    expected="_space_at_start_and_end_"
    rc=$(test_case ${test_number} ${subs} ${expected})
    test_print_result ${test_number} ${rc} ${subs} ${expected}
    tests_passed=$((${tests_passed} + ${rc}))

    test_number=5
    mkdir -p temporal && cd temporal && touch "uno dos tres"
    mkdir -p temp1 && cd temp1 && touch "cuatro cinco seis"
    cd .. && mkdir -p temp2 && cd temp2 && touch "siete ocho nueve"
    cd ../..
    all_archives_in_dir "temporal" subs_spaces
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
        printf "[%d] Test: passed.\n" ${test_number}
        tests_passed=$((${tests_passed} + ${rc}))
    fi
    rm -rf temporal

    printf "\nResult: %d/%d tests passed\n" "${tests_passed}" "${test_number}"
    if [ "${test_number}" != "${tests_passed}" ]; then
        printf "[!!] Errors detected at self_tests function\n"
    fi
}

#####-----------------------
# Main functionality

self_tests
#all_archives_in_dir $1 echo
