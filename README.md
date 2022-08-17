[GitHub](https://github.com/lllisteu/pipark) • [RubyGems](https://rubygems.org/gems/pipark) • [Documentation](https://www.rubydoc.info/gems/pipark) • [History](History.md)

# Pipark

A [Ruby](https://www.ruby-lang.org/) library for pea-brained control of [Raspberry Pi's](https://www.raspberrypi.com/).

## Installing

Pipark is [available as a gem](https://rubygems.org/gems/pipark). You can simply install it with:

```bash
gem install pipark
```

Pipark has no dependencies outside the Ruby Standard Library.

Pipark is tested on Raspbian and MacOS systems with Ruby 2.7 or newer. It may work on other platforms or with older versions of Ruby.

## Prerequisites

There are no extra steps needed to use Pipark directly on your Raspberry Pi.

To access a Raspberry Pi via the network, Pipark uses [SSH](https://en.wikipedia.org/wiki/Secure_Shell), and your Raspberry Pi needs to be set up for passwordless SSH access.

If you can enter `ssh <ip address>` or `ssh <hostname>` in a terminal to login to your Raspberry Pi, without the need to enter a password or anything else, you are all set.

See this [guide for configuring passwordless SSH access](https://www.raspberrypi.com/documentation/computers/remote-access.html#passwordless-ssh-access).

## Quick start

While logged in to your Raspberry Pi, find out its model:

```ruby
this_pi = Pipark.host('localhost')
=> Pipark::Host "localhost"
this_pi.model
=> "Raspberry Pi 3 Model B Plus Rev 1.3"
```

Shortcut:

```ruby
Pipark.localhost.model
=> "Raspberry Pi 3 Model B Plus Rev 1.3"
```

For a Raspberry Pi you can access via the network (using passwordless SSH):

```ruby
that_pi = Pipark.host('thatpi.local') # use hostname or IP address
=> Pipark::Host "thatpi.local"
that_pi.model
=> "Raspberry Pi 3 Model A Plus Rev 1.0"
that_pi.cpu_temperature
=> 48850
```

## License

See the included [LICENSE.txt](LICENSE.txt) file.
