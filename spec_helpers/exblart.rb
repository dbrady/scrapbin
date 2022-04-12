# Put me in the spec/support folder and also maybe in the
# .gitignore. ADD A #-NO-COMMIT HOOK YOU FILTHY SAVAGE!

# opens a file for appending in the rails root, and writes messages to it with timestamps.

# exblart "logfile.txt", "Here's a stupid log message"
# $ cat logfile.txt
# 2022-04-07 15:17:23.123: Here's a stupid log message
#
# logfile.txt will be in Rails.root.

# exblart "params.json", params.to_json, timestamp: false
# $ cat params.json
# {"id": 123, "these": "are", "my": "params", "etc": "etc"}


def exblart(logfile_name, msg, timestamp: false)
  time = if timestamp
           "%s: " % Time.current.strftime('%F.%T.%L')
         else
           ""
         end
  File.open(Rails.root + logfile_name, "a") do |fp|
    fp.puts "#{time} #{msg}"
  end
end
