#!/usr/bin/env python
# format_table_for_longest_column

def safelen(value):
    """Return length of value, but DWIM instead of crashing if None or Int"""
    length = 0
    try:
        length = len(value)
    except TypeError:
        length = len(f"{value}")
    return length


def build_format(results, headers):
    """Find length of longest item in each field, and return a sprintf format field"""
    longests = [len(h) for h in headers]

    for row in results:
        for index, item in enumerate(row):
            longests[index] = max(longests[index], safelen(item))

    return '| ' + ' | '.join(["%{l}s".format(l=l) for l in longests]) + " |"

def build_table_line(format):
    """Make table line bar.

e.g. for "| %3s | %2s |" print "+-----+----+"
"""

    blank_tuple = tuple([''] * format.count('%'))
    table_line = (format % blank_tuple).replace(' ', '-').replace('|', '+')
    return table_line



# Bunch of demo crap to demonstrate

# Dear Future Me: This was a BEAR until I realized that format % list does not
# work but format % tuple totally does.

headers = ("Garment", "Size", "This Header Is Longer Than Any Item", "Notes")
data = (
    ("pants", 42, "And", "Cheese"),
    ("hat", 12, "that's", "For sunny days"),
    ("galoshes", 11, "okay.", "This item is way wider than the header")
    )

format = build_format(data, headers)

table_line = build_table_line(format)

print(table_line)
print(format % headers)
print(table_line)

for row in data:
    print(format % row)
print(table_line)
