# frozen_string_literal: true

require "ecb_exchange_rates_api/options"
require "ecb_exchange_rates_api/shared_methods"
require "forwardable"
require "httparty"

module ECBExchangeRatesApi
  # Client. Provides ways for different configurations.
  class Client
    include SharedMethods
    include ::HTTParty

    extend Forwardable

    def_delegators :@options, :start_at, :end_at, :specific_date, :base, :symbols

    base_uri "https://api.exchangeratesapi.io"
    format :json

    def initialize
      @options = ECBExchangeRatesApi::Options.new
      yield self if block_given?
    end

    def fetch
      response = self.class.get(path, query: options.to_params)
      ECBExchangeRatesApi::Result.new(response.parsed_response, status: response.code)
    end

    def from(date)
      @options.start_at = date
      self
    end

    def to(date)
      @options.end_at = date
      self
    end

    def at(date)
      @options.specific_date = date
      self
    end

    def with_base(code)
      @options.base = code
      self
    end

    def for_rates(codes)
      codes.each(&method(:for_rate))
      self
    end

    def for_rate(code)
      @options.append_symbol(code)
      self
    end

    def currency_is_supported?(code)
      supported_currency?(validated_currency_code(code))
    end

    def supported_currencies
      CURRENCIES
    end

    private

    attr_reader :options

    def path
      return "/#{specific_date}" if specific_date

      return "/history" if start_at && end_at

      "/latest"
    end
  end
end
