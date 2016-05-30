#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'gorg_service'
require 'securerandom'
require 'active_record'
require  'sqlite3' # or 'pg' or 'mysql2'




BASE_PATH=File.dirname(__FILE__)
Dir[File.join(BASE_PATH,"app","**","*.rb")].each {|file| require file }

class AppConfig
  def self.value_at key
    @conf||=YAML::load(File.open(File.join(BASE_PATH,'config','conf.yml')))
    @conf[key]
  end
end



ActiveRecord::Base.establish_connection(
  adapter:  'mysql2', # or 'postgresql' or 'sqlite3'
  host:     'localhost',
  database: 'gorg_rbmq_logger',
  username: 'gorg_rbmq_logger',
  password: 'gorg_rbmq_logger'
)

GorgService.configure do |c|
  # application name for display usage
  c.application_name="My Application Name"
  # application id used to find message from this producer
  c.application_id="my_app_id"

  ## RabbitMQ configuration
  # 
  ### Authentification
  # If your RabbitMQ server is password protected put it here
  #
  # c.rabbitmq_user = nil
  # c.rabbitmq_password = nil
  #  
  ### Network configuration :
  #
  # c.rabbitmq_host = "localhost"
   c.rabbitmq_port = AppConfig.value_at "rabbitmq_port"
  #
  #
  # c.rabbitmq_queue_name = c.application_name
  # c.rabbitmq_exchange_name = "exchange"
  #
  # time before trying again on softfail in milliseconds (temporary error)
  # c.rabbitmq_deferred_time = 1800000 # 30min
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
  c.message_handler_map= {"logs" => LogMessageHandler} #TODO : Set my routing hash

 end

my_service = GorgService.new
my_service.run