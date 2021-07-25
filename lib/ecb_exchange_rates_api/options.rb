# frozen_string_literal: true

require "set"
require "ecb_exchange_rates_api/shared_methods"

module ECBExchangeRatesApi
  # Presents API params
  class Options
    include SharedMethods

    attr_reader :start_date, :end_date, :specific_date, :base, :symbols, :secured

    date_attr_writer :start_date, :end_date, :specific_date
    code_attr_writer :base

    def initialize(access_key:, secured:)
      @access_key = access_key
      @secured    = secured
      @start_date      = nil
      @end_date        = nil
      @specific_date = nil
      @base          = nil
      @symbols       = Set.new
    end

    def append_symbol(code)
      @symbols << validated_currency_code(code)
    end

    def to_params
      public_params.reject { |_, val| val.nil? || val.empty? }
    end

    private

    def public_params
      options_params.except(:secured)
    end

    def options_params
      instance_variables.each_with_object({}) do |var, hash|
        key = var.to_s[1..].to_sym
        variable = instance_variable_get(var)
        value = key == :symbols ? variable.to_a.compact.join(",") : variable
        hash[key] = value
      end
    end
  end
end
