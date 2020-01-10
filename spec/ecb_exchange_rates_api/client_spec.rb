# frozen_string_literal: true

RSpec.describe ECBExchangeRatesApi::Client do
  subject(:client) { described_class.new }

  describe "#fetch", :vcr do
    context "when any configuration was provided" do
      it "returns result instance with default base for all rates" do
        expected_base = "EUR"
        expected_currencies_list = ECBExchangeRatesApi::Constants::CURRENCIES - [expected_base]

        result = client.fetch
        expect(result).to be_a(ECBExchangeRatesApi::Result)

        expect(result.rates).to be_a(HashWithIndifferentAccess)
        expect(result.date).to be_a(String)
        expect(result.base).to be_a(String)

        expect(result.rates).to match(hash_including(*expected_currencies_list))
        expect(result.base).to eq expected_base
      end
    end

    context "when all possible parameters was configured" do
      it "returns result instance with configured params" do
        expected_base = "USD"
        expected_currencies_list = %w[GBP USD]
        expected_from = "2014-09-01"
        expected_to = "2014-09-02"

        result = described_class.new do |client|
          client.with_base expected_base
          client.for_rates expected_currencies_list
          client.from expected_from
          client.to expected_to
        end.fetch

        expect(result).to be_a(ECBExchangeRatesApi::Result)

        expect(result.rates).to be_a(HashWithIndifferentAccess)
        expect(result.start_at).to be_a(String)
        expect(result.end_at).to be_a(String)
        expect(result.base).to be_a(String)

        expect(result.rates).to match(
          expected_from => hash_including(*expected_currencies_list),
          expected_to => hash_including(*expected_currencies_list)
        )
        expect(result.base).to eq expected_base
        expect(result.start_at).to eq expected_from
        expect(result.end_at).to eq expected_to
      end
    end
  end
end
