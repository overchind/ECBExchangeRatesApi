# frozen_string_literal: true

require "ecb_exchange_rates_api/shared_methods"

module ECBExchangeRatesApi
  # Presents API params
  class Options
    include SharedMethods

    attr_reader :start_at, :end_at, :specific_date, :base, :symbols

    date_attr_writer :start_at, :end_at, :specific_date
    code_attr_writer :base

    def initialize
      @start_at      = nil
      @end_at        = nil
      @specific_date = nil
      @base          = nil
      @symbols       = []
    end

    def append_symbol(code)
      @symbols << validated_currency_code(code)
    end

    def to_params
      options_params.reject { |_, val| val.nil? || val.empty? }
    end

    private

    def options_params
      instance_variables.each_with_object({}) do |var, hash|
        key = var.to_s[1..].to_sym
        variable = instance_variable_get(var)
        value = key == :symbols ? variable&.join(",") : variable
        hash[key] = value
      end
    end
  end
end
