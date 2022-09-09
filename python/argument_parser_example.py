#!/usr/bin/env python

# See full docco at https://docs.python.org/3/library/argparse.html

import argparse
import traceback

if __name__ == '__main__':
    # parser.parse_known_args() will read from sys.argv automagically

    # If it sees -h or --help it will print a friendly help message and then
    # immediately exit.


    parser = argparse.ArgumentParser(description='Collapse first and last invoice data meta attributes to 1 row')

    parser.add_argument(
        '--pretend', '-p', help='log operations but do not perform them',
        action='store_const', const=True, required=False, default=False)

    parser.add_argument(
        '--verbose', '-v', help='Log info to logger/console',
        action='store_const', const=True, required=False, default=False)

    parser.add_argument(
        '--suppress-errors', '-s', help='Suppress error reporting to Slack/production',
        action='store_const', const=True, required=False, default=False, dest='suppress_errors')

    parsed_args, remaining_args = parser.parse_known_args()

    print("Parsed Arguments:")
    for arg, value in parsed_args:
        print(f"{arg}: {value}")

    print("Remaining Arguments:")
    print(remaining_args)
