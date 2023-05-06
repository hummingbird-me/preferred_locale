# frozen_string_literal: true

require 'active_support/concern'

class PreferredLocale
  module AutoLocale
    extend ActiveSupport::Concern

    included do
      prepend_before_action :set_locale
    end

    def set_locale
      I18n.locale = preferred_locale || I18n.default_locale
    end

    def preferred_locale
      acceptable = HeaderParser.new(request.env['HTTP_ACCEPT_LANGUAGE']).preferred_locales
      PreferredLocale.new(
        available: I18n.available_locales
      ).preferred_locale(
        locales: acceptable
      )
    end
  end
end
