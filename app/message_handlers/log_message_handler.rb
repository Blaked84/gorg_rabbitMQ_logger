#!/usr/bin/env ruby
# encoding: utf-8

class LogMessageHandler < GorgService::MessageHandler

  # This handler is based on straightforward orders passed to the daemon
  #
  # Exemple message body :
  # {
  #   "action": "create",
  #   "data": {
  #     "primary_email": "john.doe@my_domain.org",
  #     "name": {
  #       "family_name": "Doe",
  #       "given_name": "John",
  #     },
  #     "password": "11b2a5d9c9bb1633fdc13ac114d7f75031aef9dc",
  #     "hash_function": "SHA-1"
  #   }
  # }

  def initialize msg
    log_message(msg.event, msg.id, msg.data, msg.errors, msg.creation_time, msg.sender)
  end

  # Add message to database
  def log_message event, id, data, errors, creation_time, sender
    Log.create(event, id, data, errors, creation_time, sender)
  end 

  def error(msg)
    puts " [*] ERROR : #{msg}"
  end

end