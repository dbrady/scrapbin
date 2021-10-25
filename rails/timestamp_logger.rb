# timestamp_logger.rb - monkeypatch Rails logger to include timestamps
# Taken from https://stackoverflow.com/questions/5173007/add-current-time-before-log-message

# Include this in environment.rb or development.rb etc.
#
# $$ is the current process id, which Rails includes by default
class Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp} (#{$$}) #{msg}\n"
  end
end
