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
    echo $(echo "$1" | tr " " "_")
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

    printf "\nResult: %d/%d tests passed\n" "${tests_passed}" "${test_number}"
    if [ "${test_number}" != "${tests_passed}" ]; then
        printf "[!!] Errors detected at self_tests function\n"
    fi
}

#####-----------------------
# Main functionality
self_tests
