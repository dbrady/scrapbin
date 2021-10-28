#!/bin/bash
# testfunction

function quit {
    echo "quit (no more output after this line)"
    exit
}

function methods_can_use_positional_args {
    echo methods_can_use_positional_args
    echo $1
    echo $2
}

function methods_can_also_use_shift_and_arg_vars {
    echo methods_can_also_use_shift_and_arg_vars
    echo "You passed in $# arguments"
    echo "Those arguments are $@"
    echo "Popping args..."
    while [ "$1" != "" ]; do
        echo $1
        shift
        echo $#
    done
}

function methods_can_access_global_vars {
    echo methods_can_access_global_vars
    echo $1
    echo "GARG: $GARG"
}

function args_are_implicit {
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
methods_can_access_global_vars Hello
echo
args_are_implicit 'one' 'two' 'three' 'foo' 'bar' 'boo' 'squoo'
echo
quit
echo
echo "This line should not be visible as it was called after quit which calls exit"
