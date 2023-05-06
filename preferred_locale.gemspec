# frozen_string_literal: true

require_relative 'lib/preferred_locale/version'

Gem::Specification.new do |spec|
  spec.name = 'preferred_locale'
  spec.version = PreferredLocale::VERSION
  spec.authors = ['Emma Lejeck']
  spec.email = ['nuck@kitsu.io']

  spec.summary = "Get the user's preferred locale from a list of available locales"
  spec.homepage = 'https://github.com/hummingbird-me/preferred_locale'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/hummingbird-me/preferred_locale'
  spec.metadata['changelog_uri'] = 'https://github.com/hummingbird-me/preferred_locale/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ spec/ .git .github/])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
