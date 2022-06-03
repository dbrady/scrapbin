#!/usr/bin/env python

# lambda in python isn't as clean as ruby, but here goes.

# it is limited to a single expression


# lambda <args>: <expression>

# it can and MUST be all in a line

# it can be passed as an argument, though maybe only the last one, as the comma might be ambigious?

# so, yeah, can do this:

# roster = sorted(users, key=lambda user: f'{user.last_name}, {user.first_name}')
