#!/usr/bin/env python

# you can use "from datetime import datetime" to eliminate the
# "datetime.datetime.xyz()" shenanigans
import datetime

# you can

now = datetime.datetime.now()

print("You can use now.strftime('format'), like so:")
print(now.strftime("%F %T")) # %F = %Y-%m-%d and %T = %H:%M:%S

print()
print("Stack Overflow also has this to say:")
print("https://stackoverflow.com/questions/26455616/how-can-i-create-basic-timestamps-or-dates-python-3-4")

print("You can also use '{:format}'.format(now) in a formatted string, like:")
print("'Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now())")
print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))

print("or")
print("'Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now())")
print('Timestamp: {:%Y-%b-%d %H:%M:%S}'.format(datetime.datetime.now()))

print()
print("In Python 2 style you just pass it to %s")
print("'Date now: %s' % datetime.datetime.now()")
print('Date now: %s' % datetime.datetime.now())

print("'Date today: %s' % datetime.date.today()")
print(f"By the way, this is line 32 which should show up as {__LINE__}")
print('Date today: %s' % datetime.date.today())

today = datetime.date.today()
print("Today's date is {:%b, %d %Y}".format(today))

schedule = '{:%b, %d %Y}'.format(today) + ' - 6 PM to 10 PM Pacific'
schedule2 = '{:%B, %d %Y}'.format(today) + ' - 1 PM to 6 PM Central'
print('Maintenance: %s' % schedule)
print('Maintenance: %s' % schedule2)


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
