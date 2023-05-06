# PreferredLocale

A gem to help you find the best locales between what you support and what a user prefers. In
practice, this usually means finding the best locale between `I18n.available_locales` and the
`Accept-Language` header from the request, but it could also be used to find the best locale between
something in your database and a user's preferences.

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
$ bundle add preferred_locale
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
$ gem install preferred_locale
```

## Usage

To use PreferredLocale directly, you can create a new instance with your available locales:

```ruby
preferred_locale = PreferredLocale.new(available: ['en', 'fr', 'es'])
```

Then, you can find the available locales from a given list of locales from the user:

```ruby
preferred_locale.acceptable_for(['en-US', 'fr', 'ja-JP']) # => ['en', 'fr']
```

Or you can just get the best one:

```ruby
preferred_locale.preferred_for(['en-US', 'fr', 'ja-JP']) # => 'en'
```

### With Rails

PreferredLocale can be used with Rails by including the `PreferredLocale::AutoLocale` module in your
controller, which will automatically set the locale based on the `Accept-Language` header from the
request.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which
will create a git tag for the version, push git commits and the created tag, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hummingbird-me/preferred_locale.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
