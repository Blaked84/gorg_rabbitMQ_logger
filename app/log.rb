class Log < ActiveRecord::Base
	def self.create (event, id, data, errors, creation_time, sender)
		l = Log.new
		l.event = event
		l.event_id = id
		l.data = data
		l.event_errors = errors
		l.creation_time = creation_time
		l.sender = sender
		l.save
	end
end