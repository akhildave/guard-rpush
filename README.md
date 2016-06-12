# Guard::Rpush

Automatically manages rpush daemon

## Installation

Add this line to your application's Gemfile:

    gem 'guard-rpush'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guard-rpush

## Usage

Add this line to your application's Gaurdfile:

    guard 'guard-rpush'

Or with pidfile directory & environment as below:

    guard 'rpush', :pidfile => 'tmp/pids/rpush.pid', :environment => 'production' 

## Contributing

1. Fork it ( https://github.com/akhildave/guard-rpush/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
