#!/usr/bin/env python

# ruby's Enumerable.with_index roughly correlates to python's enumerate built-in:

list = ['a', 'b', 'c', 'd']
print(f"list = {list}")

print('for index, item in enumerate(list):')
print('    print(f"{index}: {item}")')
for index, item in enumerate(list):
    print(f"{index}: {item}")

print('--')

# and also has the intuitive start variable:
print('for index, item in enumerate(list, 10):')
print('    print(f"{index}: {item}")')
for index, item in enumerate(list, 10):
    print(f"{index}: {item}")
