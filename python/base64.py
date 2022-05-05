#!/usr/bin/env python

# Ruby:
#
# Base64.encode64("This is a string.")
# => "VGhpcyBpcyBhIHN0cmluZy4="
# Base64.decode64("VGhpcyBpcyBhIHN0cmluZy4=")
# =>
# "This is a string."

# Python:
#
# base64 encodes and decodes bytes to bytes, NOT to/from strings.  Use
# string.encode, bytes(), or b"" to get to bytes, and bytes.decode to
# get back to strings.
import base64

string = "This is a string."
print(string)

string_bytes1 = string.encode('utf-8')
string_bytes2 = bytes(string, 'utf-8')
string_bytes3 = b"This is a string."

base64_bytes1 = base64.b64encode(string_bytes1)
base64_bytes2 = base64.b64encode(string_bytes2)
base64_bytes3 = base64.b64encode(string_bytes3)

base64_string = base64_bytes1.decode('utf-8')
print(base64_string)

# these are already bytes if you want to round-trip immediately (not typically a useful thing, but eh)
bytes_again1 = base64.b64decode(base64_bytes1)
string_again1 = bytes_again1.decode('utf-8')
print(string_again1)
