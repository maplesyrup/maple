class LogEntry < ActiveRecord::Base
  attr_accessible :additt_version, :android_build, :time, :stack_trace
end
