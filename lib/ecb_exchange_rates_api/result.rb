# frozen_string_literal: true

require "active_support/core_ext/hash"

module ECBExchangeRatesApi
  # Wrapper for HTTParty response object
  class Result
    attr_reader :data, :status

    def initialize(data, status: 200)
      data = {} unless data.is_a?(Hash)

      @status = status
      @data = OpenStruct.new(data.with_indifferent_access)
    end

    def success?
      status == 200
    end

    def error?
      !success?
    end

    private

    def method_missing(method_name, *arguments, &block)
      if @data.respond_to?(method_name)
        @data.send(method_name, *arguments, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @data.respond_to?(method_name) || super
    end
  end
end
