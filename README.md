# GorgRabbitMQLogger

GorgRabbitMQLogger is a RabbitMQ Logger reccording all messages using Gadz.org SOA JSON Schema in a database.

## Setup
  
Before being used, GorgRabbitMQLogger must be configured. Copy `conf.yml.template` to `conf.yml` and set your parameters.

The database must contain a `logs` table with the following schema : 
```
id,INT
data,VARCHAR
event,VARCHAR
event_id,VARCHAR
event_errors,VARCHAR
creation_time,VARCHAR
sender,VARCHAR
```

## Usage

To start the daemon, juste run in the:  
```bash
./worker.rb
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec --format doc` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Blaked84/gorg_rabbitMQ_logger.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

