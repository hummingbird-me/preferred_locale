# frozen_string_literal: true

require_relative 'preferred_locale/version'
require_relative 'preferred_locale/header_parser'
require_relative 'preferred_locale/auto_locale' if defined?(Rails)

class PreferredLocale
  def initialize(available: [])
    # We need this to avoid overwriting explicit options with implicit ones
    available_lower = available.map { |locale| locale.to_s.downcase }

    # Create a map of "implicit" available locales to their "canonical" form
    @available = available.each_with_object({}) do |locale, obj|
      locale_str = locale.to_s
      obj[locale_str.downcase] = locale
      # Add the language without a country if it's not already in the list
      language = locale_str.downcase.split('-')[0]
      obj[language] = locale unless available_lower.include?(language)
    end
  end

  def acceptable_for(locales: [])
    # Build a candidate list including our implicit candidate locales
    candidates = locales.flat_map do |locale|
      [locale.to_s.downcase, locale.to_s.split('-')[0].downcase]
    end

    # Figure out which candidates are available
    available = candidates.filter do |locale|
      @available.key?(locale.downcase)
    end

    # Convert to the canonical form and then remove duplicates
    available.map { |locale| @available[locale.downcase] }.uniq
  end

  def preferred_for(locales: [])
    acceptable_for(locales: locales)[0]
  end
end
