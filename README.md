# PreferredLocale

A gem to help you find the best locales between what you support and what a user prefers. In
practice, this usually means finding the best locale between `I18n.available_locales` and the
`Accept-Language` header from the request, but it could also be used to find the best locale between
something in your database and a user's preferences.

This is similar to the [http_accept_language gem](https://github.com/iain/http_accept_language) and
the [preferred-locale JS library](https://github.com/wopian/preferred-locale) in that it attempts to
resolve mismatches in specificity (ie, `en-US` vs `en`), but differs slightly in algorithm and in
API design.

## Algorithm

For available locales from the application:

1. Start with available locales:
   - `['en-US', 'pt-BR', 'ja-JP', 'pt']`
2. Normalize them to lowercase mapped to the original values:
   - `{'en-us' => 'en-US', 'pt-br' => 'pt-BR', 'ja-jp' => 'ja-JP', 'pt' => 'pt'}`
3. Add "implicit" locales as fallbacks:
   - `{'en-us' => 'en-US', 'en' => 'en-US', 'pt-br' => 'pt-BR', 'ja-jp' => 'ja-JP', 'ja' => 'ja-JP',
     'pt' => 'pt'}`
   - Note that `en` and `ja` are added as fallbacks for `en-US` and `ja-JP` respectively, but *not*
     for `pt-BR` because `pt` is already in the list later.

Now to match a user's preferred locales:

1. Start with preferred locales:
   - `['en-US', 'fr', 'ja-JP', 'en']`
2. Normalize them to lowercase:
   - `['en-us', 'fr', 'ja-jp', 'en']`
3. Add "implicit" locales as fallbacks:
   - `['en-us', 'fr', 'ja-jp', 'ja', 'en']`
   - As above, note that `en` is *not* added as a fallback for `en-us` because it is already in the
     list.
4. Filter out locales that are not available:
   - `['en-us', 'ja-jp', 'ja', 'en']`
5. Convert to the canonical form
   - `['en-US', 'ja-JP', 'ja-JP', 'en-US']`
6. Remove duplicates
   - `['en-US', 'ja-JP']`

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
preferred_locale.acceptable_for(locales: ['en-US', 'fr', 'ja-JP']) # => ['en', 'fr']
```

Or you can just get the best one:

```ruby
preferred_locale.preferred_for(locales: ['en-US', 'fr', 'ja-JP']) # => 'en'
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
