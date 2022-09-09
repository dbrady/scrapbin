#!/usr/bin/env python
# map built-in

print("""map(fn, list)""")

def capitalize(text):
    return f"{text[0].upper()}{text[1:]}"

names = ["alice", "bob", "carol", "dave", "eddie", "frances", "george", "hannah", "x"]

capitalized_names = map(capitalize, names)

print("Names:")
print(', '.join(names))
print('--')
print('capitalized_names = map(capitalize, names)')
print('capitalized_names:')
print(', '.join(capitalized_names))
