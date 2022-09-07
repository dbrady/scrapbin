#!/usr/bin/env python
import re

# replacing stuff in strings

print("Replace static substring with new substring:")
print('"foo bar baz qux".replace("bar", "HELLO")')
print("foo bar baz qux".replace("bar", "HELLO"))

print()
print("Replace regex with static substring (without match)")
print('re.sub("b.*z", "HELLO", "foo bar baz qux")')
print(re.sub("b.*z", "HELLO", "foo bar baz qux"))

print()
print("Replace regex with substring including match")
print('re.sub("b([a-z]*)", "B\\1", "foo bar baz baaz qux")')
print(re.sub("b([a-z]*)", "B\\1", "foo bar baz baaz qux"))
print("raw strings (r'...') do not need to escape the backslash:")
print('re.sub("b([a-z]*)", r"B\\1", "foo bar baz baaz qux")')
print(re.sub("b([a-z]*)", r"B\1", "foo bar baz baaz qux"))
