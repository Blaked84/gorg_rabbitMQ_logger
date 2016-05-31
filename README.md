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
./logger_daemon.rb
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Blaked84/gorg_rabbitMQ_logger.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

