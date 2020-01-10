# frozen_string_literal: true

module ECBExchangeRatesApi
  # Presents API params
  module SharedMethods
    # ::nodoc::
    module Attributes
      private

      def date_attr_writer(*attr_names)
        attr_names.each do |attr_name|
          define_method("#{attr_name}=") do |date|
            instance_variable_set("@#{attr_name}", represent_date(date))
          end
        end
      end

      def code_attr_writer(*attr_names)
        attr_names.each do |attr_name|
          define_method("#{attr_name}=") do |code|
            instance_variable_set("@#{attr_name}", validated_currency_code(code))
          end
        end
      end
    end
  end
end
