#!/usr/bin/env python

import datetime
import csv

now = datetime.datetime.now()

data = [
    [1, "NameWithNoSpacesOrSpecialCh", "", None, now],
    [2, "Name With Lots Of Spaces XX", "", None, now],
    [3, "Comma, Name With Spaces And", "", None, now]
]

quoting_modes = {
    # Quotes everything. None and empty strings both appear as empty strings.
    csv.QUOTE_ALL: "QUOTE_ALL",

    # Quotes nothing but the name on line 3. None and empty strinsg both appear as null/missing fields
    csv.QUOTE_MINIMAL: "QUOTE_MINIMAL",

    # Quotes on everything except for the id column. None and empty both appear as empty strings
    csv.QUOTE_NONNUMERIC: "QUOTE_NONNUMERIC",

    # No quotes anywhere, but fails to write line 3. None and empty both appear as null/missing fields
    csv.QUOTE_NONE: "QUOTE_NONE"
    }

for mode, name in quoting_modes.items():
    filename = f"csv-data-quoted-as-{name.lower()}.csv"
    print(filename)
    try:
        with open(filename, "w") as file:
            writer = csv.writer(file, quoting=mode)
            for row in data:
                writer.writerow(row)
    except Exception as e:
        print("Error on write")
        pass

# Okay, let's split None and empty strings. We're going to replace None values
# with custom EmptyString objects that can be "quoted" by csv writer as a
# missing strings Looking at the output, we're going to want this combined with
# QUOTE_NONNUMERIC to get empty strings as "" and None values as null/empty
# values.

class EmptyString(int):
    def __str__(self):
        return ''
EmptyString = EmptyString()

def replace_none_with_emptystring(row):
  return [
    val if val is not None else EmptyString
    for val in row
  ]

for mode, name in quoting_modes.items():
    filename = f"csv-data-quoted-as-{name.lower()}-with-custom-nulls.csv"
    print(filename)
    try:
        with open(filename, "w") as file:
            writer = csv.writer(file, quoting=mode)
            for row in data:
                writer.writerow(replace_none_with_emptystring(row))

    except Exception as e:
        print("Error on write")
        pass
