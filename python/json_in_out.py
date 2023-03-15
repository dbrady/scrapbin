#!/usr/bin/env python

import json

print("Reading test-in.json...")
with open("test-in.json", "r") as infile:
    indata = infile.read()

outdata = json.loads(indata)

print(indata)
print(outdata)

with open("test-out.json", "w") as file:
    # file.write(json.dumps(outdata))
    json.dump(outdata, file)

print("Wrote test-out.json.")
