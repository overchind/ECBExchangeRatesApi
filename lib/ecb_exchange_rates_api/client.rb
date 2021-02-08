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
      create_result(response.parsed_response, response.code)
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

    def convert(amount, base_code = nil, codes = nil, date = nil)
      response = self.class.new do |client|
        client.with_base presented_base(base_code)
        client.for_rates presented_symbols(codes)
        client.at presented_date(date)
      end.fetch

      response.rates.transform_values! { |v| v * amount }
      response
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

    def create_result(response, status)
      ECBExchangeRatesApi::Result.new(response, status: status)
    end

    def presented_base(base_from_params)
      base_from_params || base || default_base
    end

    def presented_symbols(codes)
      (codes && Array.wrap(codes)) || symbols || []
    end

    def presented_date(date)
      date || specific_date || current_date
    end
  end
end
