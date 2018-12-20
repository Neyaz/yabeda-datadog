# Yabeda::[DataDog]

Adapter for easy exporting your collected metrics from your application to the [DataDog]!

## Installation

 1. [Register and install DataDog Agent on your system](https://www.datadoghq.com).

 2. Add this line to your application's Gemfile:

    ```ruby
    gem 'yabeda-datadog', :git => "git@github.com:Neyaz/yabeda-datadog.git"
    ```

    And then execute:

        $ bundle
  3. Export DataDog API in system variables
    ```
    export DD_API_KEY=YOUR_KEY
    ``` 
  4. Export period for collect block execution in system variables
    ```
    export DATADOG_COLLECT_PERIOD=PERIOD
    ```   
    For expemple: 3s, 3h, 3h30m
    
    For more information follow [rufus-sheduler](https://github.com/jmettraux/rufus-scheduler)
  5. Run sheduler
    ```ruby
    Yabeda::DataDog::Collector.start_collect!
    ```

## Usage

All metrics registered in [Yabeda] will be sent to DataDog automatically.

Go to [DataDog] → Metrics → Explorer.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Neyaz/yabeda-datadog.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).