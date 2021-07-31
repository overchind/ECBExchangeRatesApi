# frozen_string_literal: true

require "ecb_exchange_rates_api/options"
require "ecb_exchange_rates_api/shared_methods"
require "ecb_exchange_rates_api/endpoint_generator"
require "forwardable"
require "httparty"

module ECBExchangeRatesApi
  # Client. Provides ways for different configurations.
  class Client
    include SharedMethods
    include ::HTTParty

    extend Forwardable

    def_delegators :@options, :start_date, :end_date, :date, :base, :symbols

    format :json

    def initialize(access_key:, secured: false)
      @options = create_options(access_key)
      @secured = secured
      yield self if block_given?
    end

    def fetch
      endpoint = EndpointGenerator.new(@options, @secured).call
      response = self.class.get(endpoint, query: @options.to_params)
      create_result(response.parsed_response, response.code)
    end

    def timeseries(start_date, end_date)
      @options.start_date = start_date
      @options.end_date = end_date
      self
    end

    def at(date)
      @options.date = date
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

    def convert(from, to, amount)
      @options.from = from
      @options.to = to
      @options.amount = amount
      self
    end

    def fluctuation(enable: true)
      @options.fluctuation = enable
      self
    end

    def currency_is_supported?(code)
      supported_currency?(validated_currency_code(code))
    end

    def supported_currencies
      CURRENCIES
    end

    private

    def create_options(access_key)
      ECBExchangeRatesApi::Options.new(access_key: access_key)
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

    def presented_date(param)
      param || date || current_date
    end
  end
end
