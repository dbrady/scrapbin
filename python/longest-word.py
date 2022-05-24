#!/usr/bin/env python

# Often, such as when formatting a column of words, I need to know the length of
# the longest word in the column. I do this in ruby with words.map(&:size).max.
# In Python it's similarly concise:

words = [
    'exsanguinous',
    'wolfdom',
    'Cryptobranchia',
    'Heterognathi',
    'trichopathy',
    'underroot',
    'autocholecystectomy',
    'Dorylinae',
    'sialaden',
    'koolah',
    'baft',
    'moulinet',
    'creophagy',
    'struvite',
    'redevelop',
    'tormentable',
    'spatular',
    'rebid',
    'Echinacea',
    'unquibbling'
]

print('Words:')
print(words)
longest_length = max(len(word) for word in words)
print(f'Length of longest word: {longest_length}')
