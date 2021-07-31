# frozen_string_literal: true

require "ecb_exchange_rates_api/shared_methods"
require "forwardable"

module ECBExchangeRatesApi
  # Presents API params
  class EndpointGenerator
    extend Forwardable
    def_delegators :@options, :date, :start_date, :end_date, :secured,
                   :from, :to, :amount, :fluctuation

    def initialize(options)
      @options = options
    end

    def call
      URI.join(base, path).to_s
    end

    private

    def base
      "#{protocol}://#{ECBExchangeRatesApi::Constants::API_URL}"
    end

    def path
      return "/fluctuation" if fluctuation

      return "/convert" if from && to && amount

      return "/#{date}" if date

      return "/timeseries" if start_date && end_date

      "/latest"
    end

    def protocol
      secured ? "https" : "http"
    end
  end
end
