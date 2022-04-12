#!/usr/bin/env python

def pants(source):
    print("This is running from the " + source)

pants("bare file root on load")

# Equivalent to ruby's if __FILE__ == $0
if __name__ == "__main__":
    print("This message is printed directly from the if name is main block")
    pants("main block")
