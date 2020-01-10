# frozen_string_literal: true

module ECBExchangeRatesApi
  module Constants
    CURRENCIES = %w[USD GBP EUR JPY BGN CZK DKK HUF PLN RON
                    SEK CHF ISK NOK HRK RUB TRY AUD BRL CAD
                    CNY HKD IDR ILS INR KRW MXN MYR NZD PHP
                    SGD THB ZAR].freeze

    CURRENCY_REGEXP = /^[A-Z]{3}$/.freeze

    # rubocop:disable Metrics/LineLength
    DATE_REGEXP = /^[0-9]{4}-((([13578]|0[13578]|(10|12))-([1-9]|0[1-9]|[1-2][0-9]|3[0-1]))|(02-(0[1-9]|[1-2][0-9]))|(([469]|0[469]|11)-([1-9]|0[1-9]|[1-2][0-9]|30)))$/.freeze
    # rubocop:enable Metrics/LineLength
  end
end
