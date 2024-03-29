#!/usr/bin/env python

# Can we write our own context managers? (Context: I don't mean is it physically
# possible, I mean we currently do not use these and it may present as an
# overcomplicated concept. Is it within the scope of our team's learning and
# comfort curves to include them in our DS package?)

# E.g. we have a DB class that we want to open a connection that should be
# closed (possibly to ensure I/O gets flushed).

# A CM has two methods, __enter__ and __exit__.


# class File(object):
#     def __init__(self, file_name, method):
#         self.file_obj = open(file_name, method)
#     def __enter__(self):
#         return self.file_obj
#     def __exit__(self, type, value, traceback):
#         self.file_obj.close()


# with File(__file__, "r") as f:
#     print(f.read())


# ----------------------------------------------------------------------
# A Context Manager for CSV Files
# ----------------------------------------------------------------------

# OOOH. Or here's an actually useful version of it. Please note dependency on
# widgets-sae.csv and widgets-metric.csv, which I have added to the repo.

# given an input csv file of widgets in SAE, let's create an output
# file of metric widgets, rounding size to the nearest millimeter.

import csv

# without Context Manager
# with open("widgets-sae.csv") as infile:
#     with open("widgets-metric.csv", "w") as outfile:
#         writer = csv.writer(outfile)
#         writer.writerow(["id", "name", "size", "color"])

#         reader = csv.DictReader(infile)
#         for row in reader:
#             mm = round(25.4 * float(row["size"]))
#             new_size = f"{mm}mm"

#             writer.writerow([row["id"], row["name"], new_size, row["color"]])


# and with a Context Manager
class CsvWriter:
    def __init__(self, filename, headers=None):
        self.filename = filename
        self.outfile = open(filename, "w")
        self.writer = csv.writer(self.outfile)
        self.headers = headers
        if self.headers is not None:
            self.writer.writerow(headers)

    def __enter__(self):
        return self.writer

    def __exit__(self, exception_type, exception_value, traceback):
        self.outfile.close()

class CsvDictReaderContextManager:
    def __init__(self, filename):
        self.filename = filename
        self.infile = open(filename)
        self.reader = csv.DictReader(self.infile)

    def __enter__(self):
        return self.reader

    def __exit__(self, exception_type, exception_value, traceback):
        self.infile.close()



# with CsvDictReaderContextManager("widgets-sae.csv") as reader:
#     with CsvWriterContextManager("widgets-metric.csv") as writer:
#         writer.writerow(["id", "name", "size", "color"])
#         for row in reader:
#             mm = round(25.4 * float(row["size"]))
#             new_size = f"{mm}mm"
#             writer.writerow([row["id"], row["name"], new_size, row["color"]])

# This would rival ruby's expressiveness if csv.writer were a Context Manager.
# with csv.writer(open("widgets-metric.csv", "w")) as writer:

with CsvWriter("widgets-metric.csv") as writer:
    writer.writerow(["id", "name", "size", "color"])
    for row in csv.DictReader(open("widgets-sae.csv")):
        mm = round(25.4 * float(row["size"]))
        new_size = f"{mm}mm"
        writer.writerow([row["id"], row["name"], new_size, row["color"]])



# hmm, could also send the headers to the context manager:
# headers = ["id", "name", "size", "color"]
# with WritableCsv("widgets-metric.csv", headers=headers) as writer:
#     for row in csv.DictReader(open("widgets-sae.csv")):
#         mm = round(25.4 * float(row["size"]))
#         writer.writerow([row["id"], row["name"], f"{mm}mm", row["color"]])

# ----------------------------------------------------------------------
# A Context Manager For Logging
# ----------------------------------------------------------------------

# Remember way back when, in C++, when I loved the fact that destructors
# automatically got called when an object passed out of scope, and we used that
# to have entry/exit loggers that could log exactly when their scope was
# destroyed? And how I had to abandon this is GC languages, even with Ruby and
# Python's finalizers, because they run only as a courtesy at garbage
# collection, and might not even run at all at program exit? Yeah. Bummer.

# But! We could try using a context manager, like so:

# def my_func(*args, **kwargs):
#     with ScopeLogger("my_func") as logger:
#         logger.log("whatever")

# It's not perfectly transparent (in Python you'd have to indent/outdent the
# whole function every time you added and removed it (and remember a lot of my
# code has to be quickly shimmed in and out with "nocommit" comments.


import os, datetime

class ScopeLogger:
    # TODO: maybe make class vars to configure the logging directory and/or a
    # central logging system, then all the ScopeLoggers would communicate
    # through that rather than knowing where the logging folder is.
    def __init__(self, name):
        self.name = name
        self.filename = os.path.expanduser(f"~/logs/{self.timestamp()}.log")
        self.logfile = open(filename, "a")

    def __enter__(self):
        return self

    def __exit__(self, exception_type, exception_value, traceback):
        self.logfile.close()

    def log(self, msg):
        self.logfile.write(f"{self.timestamp()} {self.name}: {msg}\n")

    def timestamp(self):
        datetime.datetime.now().strftime('%F')
