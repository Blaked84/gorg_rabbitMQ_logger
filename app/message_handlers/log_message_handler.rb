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
  #
  # It accepts 3 actions :
  #  - create
  #  - update
  #  - delete

  def initialize msg
    data=prepare_data(msg.data)
    log_message(data)
  end

  # Expect data to contain :
  #  -name
  #  -password
  #  -primary_email

  def log_message data
    puts "##----new message"
    puts  data
    a = Log.new
    a.data = data
    a.save
  end

  def create_user data
    if data.values_at(:name,:password,:primary_email).all?
      unless GUser.find(data[:primary_email])
        user=GUser.new
        user.update!(**data)
        user.save
        puts " [x] User #{data[:primary_email]} created"
      else
        error("Existing user")
        raise_softfail "Existing User"
      end
    else
      error("Invalid Data")
      raise_hardfail "Invalid Data"
    end
  end  

  def prepare_data data
    s2s = 
    lambda do |h| 
      Hash === h ? 
        Hash[
          h.map do |k, v| 
            [k.respond_to?(:to_sym) ? k.to_sym : k, s2s[v]] 
          end 
        ] : h 
    end
    s2s[data]
  end


  def error(msg)
    puts " [*] ERROR : #{msg}"
  end

end