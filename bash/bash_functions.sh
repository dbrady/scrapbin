#!/bin/bash
# testfunction

echo "Good tutorial here: https://phoenixnap.com/kb/bash-function"
echo
echo "Run bash in debug mode:"
echo "    bash --debugger"
echo
echo "In debug mode, find where/how a function is defined with"
echo "declare -F myfunc"
echo
echo "Or just see the source of the function with"
echo "declare -f myfunc"
echo
echo "Delete a bash function with unset:"
echo "unset myfunc"
echo

function quit {
    echo "Called: quit (no more output after this line)"
    exit
}

function methods_can_use_positional_args {
    echo "Called: methods_can_use_positional_args $@"
    echo $1
    echo $2
}

function methods_can_also_use_shift_and_arg_vars {
    echo "Called: methods_can_also_use_shift_and_arg_vars $@"
    echo "You passed in $# arguments"
    echo "Those arguments are $@"
    echo 'Shifting args while $1 is not blank...'
    while [ "$1" != "" ]; do
        echo '$1 is' $1
        echo "shift"
        shift
        echo '$# is' $#
    done
}

function methods_can_access_global_vars {
    echo "Called: methods_can_access_global_vars $@"
    echo Inside methods_can_access_global_vars, before overriding, global_var is $global_var and local_var is $local_var
    global_var=global_changed
    local local_var=local_changed
    echo Inside methods_can_access_global_vars, after overriding, global_var is $global_var and local_var is $local_var
}

function args_are_implicit {
    echo "Called: args_are_implicit $@"
    echo args_are_implicit
    echo "1: $1"
    echo "3: $3"
    echo '$*: ' $*
}

GARG=World

methods_can_use_positional_args alpha beta
echo

methods_can_also_use_shift_and_arg_vars foo bar baz
echo

global_var=global
local_var=local
echo Before calling methods_can_access_global_vars, global_var is $global_var and local_var is $local_var
methods_can_access_global_vars
echo After calling methods_can_access_global_vars, global_var is $global_var and local_var is $local_var
echo

args_are_implicit 'one' 'two' 'three' 'foo' 'bar' 'boo' 'squoo'
echo

quit
echo
echo "This line should not be visible as it was called after quit which calls exit"
