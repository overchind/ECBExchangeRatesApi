# frozen_string_literal: true

require "ecb_exchange_rates_api/shared_methods/attributes"
require "ecb_exchange_rates_api/constants"
require "ecb_exchange_rates_api/errors"

module ECBExchangeRatesApi
  # ::nodoc::
  module SharedMethods
    extend SharedMethods::Attributes

    def self.included(base)
      base.send :extend, SharedMethods::Attributes
    end

    private

    def default_base
      ECBExchangeRatesApi::Constants::DEFAULT_BASE
    end

    def current_date
      represent_date(Time.now)
    end

    def represent_date(date)
      return date.strftime("%Y-%m-%d") if time_or_date_instance?(date)

      return date if date.is_a?(String) && date =~ ECBExchangeRatesApi::Constants::DATE_REGEXP

      raise InvalidDateFormatError, date
    end

    def time_or_date_instance?(instance)
      instance.is_a?(Date) || instance.is_a?(Time)
    end

    def validated_currency_code(code)
      currency = sanitize_currency_code(code)
      raise InvalidCurrencyCodeError, "Ivalid code format #{code}" unless valid_currency_code_format?(currency)

      return unless supported_currency?(currency)

      currency
    end

    def supported_currency?(currency)
      ECBExchangeRatesApi::Constants::CURRENCIES.include?(currency)
    end

    def valid_currency_code_format?(currency_code)
      !currency_code.nil? && currency_code =~ ECBExchangeRatesApi::Constants::CURRENCY_REGEXP
    end

    def sanitize_currency_code(code)
      code&.strip&.upcase
    end
  end
end
