#!/usr/bin/env python

# LOL - can't call this file 'base64.py' because import base64 will
# see this file before the one in site packages, causing a circular
# import

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

# +----------------------------+                           +-----------------------------+
# | String                     |                           | Bytes                       |
# +----------------------------+                           +-----------------------------+
# | "This is a string."        |--encode('utf-8')--------->| b'This is a string.'        |
# +----------------------------+                           +-----------------------------+
#                                                                 |              ^
#                                                      base64.b64encode(bytes)   |
#                                                                 |              |
#                                                                 |              |
#                                                                 |              |
#                                                                 |    base64.b64decode(bytes)
#                                                                 v              |
# +----------------------------+                           +-----------------------------+
# | String                     |                           | Bytes                       |
# +----------------------------+                           +-----------------------------+
# | "VGhpcyBpcyBhIHN0cmluZy4=" |<---------decode('utf-8')--| b'VGhpcyBpcyBhIHN0cmluZy4=' |
# +----------------------------+                           +-----------------------------+
import base64

string = "This is a string."
print(string)

string_bytes1 = string.encode('utf-8')
string_bytes2 = bytes(string, 'utf-8')
string_bytes3 = b"This is a string."

base64_bytes1 = base64.b64encode(string_bytes1)
base64_bytes2 = base64.b64encode(string_bytes2)
base64_bytes3 = base64.b64encode(string_bytes3)
# b'VGhpcyBpcyBhIHN0cmluZy4='

base64_string = base64_bytes1.decode('utf-8')
# 'VGhpcyBpcyBhIHN0cmluZy4=' <-- '', not b'', because string, not bytes
print(base64_string)

# these are already bytes if you want to round-trip immediately (not typically a useful thing, but eh)
bytes_again1 = base64.b64decode(base64_bytes1)
string_again1 = bytes_again1.decode('utf-8')
print(string_again1)
