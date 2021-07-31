# frozen_string_literal: true

require "set"
require "ecb_exchange_rates_api/shared_methods"

module ECBExchangeRatesApi
  # Presents API params
  class Options
    include SharedMethods

    attr_reader :start_date, :end_date, :date,
                :base, :symbols, :from, :to, :secured

    date_attr_writer :start_date, :end_date, :date
    code_attr_writer :base, :from, :to
    attr_accessor :amount

    def initialize(access_key:, secured:)
      @access_key      = access_key
      @secured         = secured
      @symbols         = Set.new
    end

    def append_symbol(code)
      @symbols << validated_currency_code(code)
    end

    def to_params
      public_params.reject { |key, val| val.nil? || (key != :amount && val.empty?) }
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
