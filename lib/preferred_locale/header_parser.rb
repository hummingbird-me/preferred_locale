# frozen_string_literal: true

class PreferredLocale
  class HeaderParser
    def initialize(header)
      @header = header.to_s
    end

    def raw_locales
      @raw_locales ||= begin
        values = @header.split(/,\s*/).map do |item|
          locale, quality = item.split(';q=')
          [locale, quality ? quality.to_f : 1.0]
        end
        values.sort { |(_, a), (_, b)| b <=> a }.filter_map(&:first)
      end
    end

    def preferred_locales
      raw_locales.filter do |locale|
        locale.match(/^[-a-z0-9]+$/i)
      end
    end
  end
end
