#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'gorg_service'
require 'securerandom'
require 'active_record'
require  'mysql2' # or 'pg' or 'sqlite3'


class LoggerDaemon
  #Load apps file and conf
  BASE_PATH=File.dirname(__FILE__)
  Dir[File.join(BASE_PATH,"app","**","*.rb")].each {|file| require file }

  CONFIG ||= YAML::load(File.open(File.join(BASE_PATH,'config','conf.yml')))

  # Database configuration
  ActiveRecord::Base.establish_connection(
    adapter:  CONFIG["database"]["adapter"], # or 'postgresql' or 'sqlite3'
    host:     CONFIG["database"]["host"],
    port:     CONFIG["database"]["port"],
    database: CONFIG["database"]["database"],
    username: CONFIG["database"]["username"],
    password: CONFIG["database"]["password"]
  )

  #Gorg RabbitMQ conf
  GorgService.configure do |c|
    # application name for display usage
    c.application_name=CONFIG["application_name"]
    # application id used to find message from this producer
    c.application_id=CONFIG["application_id"]

    ## RabbitMQ configuration
    # 
    ### Authentification
    # If your RabbitMQ server is password protected put it here
    #
    c.rabbitmq_user = CONFIG["rabbitmq"]["user"]
    c.rabbitmq_password = CONFIG["rabbitmq"]["password"]
    #  
    ### Network configuration :
    #
    c.rabbitmq_host = CONFIG["rabbitmq"]["host"]
    c.rabbitmq_port = CONFIG["rabbitmq"]["port"]
    c.rabbitmq_queue_name = CONFIG["rabbitmq"]["queue_name"]
    c.rabbitmq_exchange_name = CONFIG["rabbitmq"]["exchange_name"]
    #
    # time before trying again on softfail in milliseconds (temporary error)
    c.rabbitmq_deferred_time = CONFIG["rabbitmq"]["deferred_time"]
    # 
    # maximum number of try before discard a message
    # c.rabbitmq_max_attempts = 48 # 24h with default deferring delay
    #
    # Routing hash
    #  map routing_key of received message with MessageHandler 
    #  exemple:
    # c.message_handler_map={
    #   "some.routing.key" => MyMessageHandler,
    #   "Another.routing.key" => OtherMessageHandler,
    #   "third.routing.key" => MyMessageHandler,
    # }
    c.message_handler_map= Hash[CONFIG["message_handler_map"].map{ |k, v| [k, eval(v)] }]

  end
  
  def run
    begin
      self.start
      loop do
        sleep(1)
      end
    rescue SystemExit, Interrupt => _
      self.stop
    end
  end

  def start
   my_service.start
  end

  def stop
    my_service.stop
  end
end


