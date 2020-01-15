def elapsed_time(start, finish)
  hours, minutes = nil
  seconds = (finish - start)
  if seconds > 3600
    minutes = 0
    hours = (seconds / 3600).to_i
    seconds -= hours * 3600
  end
  if seconds > 60
    minutes = (seconds / 60).to_i
    seconds -= minutes * 60
  end
  format = if hours
             "%d:%02d:%05.2f"
           elsif minutes
             "%02d:%05.2f"
           else
             "%05.2f"
           end
  sprintf(format, *([hours, minutes,seconds].compact)).sub(/: /, ':0')
end

if __FILE__==$0
  finish = Time.now
  finish_i = finish.to_i

  intervals = {
    just_a_bit_ago: 15,
    a_few_minutes_ago: 314,
    a_little_while_ago: 3059,
    a_while_ago: 8375,
    a_few_hours_ago: 36189,
    a_day_ago: 86400,
    a_few_days_ago: 386400
  }
  longest = intervals.keys.map(&:to_s).map(&:size).max
  format = "%#{longest}s: %12s"

  puts "Elapsed Time Intervals Examples"
  puts "Interval".ljust(longest+1) + "Display".rjust(12)
  intervals.each_pair do |name, sec|
    start = Time.at(finish_i - sec)
    puts name.to_s.gsub(/_/, ' ').capitalize.ljust(longest+1, '.') + elapsed_time(start, finish).rjust(12, '.')
#    puts format % [name, ]
  end
end
