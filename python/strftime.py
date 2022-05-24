#!/usr/bin/env python
from datetime import datetime

now = datetime.now()
print(now.strftime("%F %T")) # %F = %Y-%m-%d and %T = %H:%M:%S


# in data_services you may see system.get_time(...); this is a custom method we
# wrote in data_services_package/dataservices/system.py.

# By default it returns now() in the format '%F %T' ('%Y-%m-%d %H:%M:%S'). It
# has a crapton of magic helpers in the date_type field, which can control the
# format (e.g. 'file_date2' => '%m%d%Y'), offset relative to reference time
# (e.g. '120' => 120 days), or return data type ('epoch' => int). Most of the
# offset times appear to override the format (e.g. 'somonth' => start of month,
# but always as string in '%Y-%m-%d' format)

# import system
# systime = system.Time()

# if date is a string, it is sent to parser.parse(date)
# https://dateutil.readthedocs.io/en/stable/parser.html
# from datetime import parser

# if date is a datetime, it is used directly
# if date is None, datetime.now() is used
# date = args.date or None
# date = None # date format

# print(systime.get_time('file_date', date))
