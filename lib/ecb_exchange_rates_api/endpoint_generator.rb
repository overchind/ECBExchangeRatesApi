# frozen_string_literal: true

require "ecb_exchange_rates_api/shared_methods"
require "forwardable"

module ECBExchangeRatesApi
  # Presents API params
  class EndpointGenerator
    extend Forwardable
    def_delegators :@options, :date, :start_date, :end_date,
                   :from, :to, :amount, :fluctuation

    def initialize(options, secured)
      @options = options
      @secured = secured
    end

    def call
      URI.join(base, path).to_s
    end

    private

    def base
      "#{protocol}://#{ECBExchangeRatesApi::Constants::API_URL}"
    end

    def path
      valid_endpoint = valid_endpoints.keys.first
      case valid_endpoint
      when :date
        "/#{date}"
      when :default
        "/latest"
      else
        "/#{valid_endpoint}"
      end
    end

    def valid_endpoints
      {
        fluctuation: fluctuation,
        convert: from && to && amount,
        date: date,
        timeseries: start_date && end_date,
        default: true
      }.reject { |_, v| v.nil? || !v }
    end

    def protocol
      @secured ? "https" : "http"
    end
  end
end
