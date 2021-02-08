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

  describe "#convert", :vcr do
    context "when all parameters are configured with convert arguments and other options are not used" do
      it "uses convert args and multiplies rates field with passed amount" do
        fetch_result = client.with_base("USD").for_rates(%w[EUR SEK]).at("2007-09-16").fetch
        convert_result = client.convert(20, "USD", %w[EUR SEK], "2007-09-16")
        expect(convert_result).to be_a(ECBExchangeRatesApi::Result)

        expect(convert_result.rates).to be_a(HashWithIndifferentAccess)
        expect(convert_result.date).to be_a(String)
        expect(convert_result.base).to be_a(String)
        rates = fetch_result.rates.values.map { |v| v * 20 }
        expect(convert_result.rates.values).to eq rates
      end
    end

    context "when all parameters are configured with convert arguments and other options also present" do
      it "uses convert args and multiplies rates field with passed amount" do
        fetch_result = client.with_base("USD").for_rates(%w[EUR SEK]).at("2007-09-16").fetch
        convert_result = client.with_base("EUR")
                               .for_rates(%w[PHP RUB])
                               .at("2009-01-01")
                               .convert(20, "USD", %w[EUR SEK], "2007-09-16")
        expect(convert_result).to be_a(ECBExchangeRatesApi::Result)

        expect(convert_result.rates).to be_a(HashWithIndifferentAccess)
        expect(convert_result.date).to be_a(String)
        expect(convert_result.base).to be_a(String)
        rates = fetch_result.rates.values.map { |v| v * 20 }
        expect(convert_result.rates.values).to eq rates
      end
    end

    context "when convert arguments skipped and other options present" do
      it "uses client options and multiplies rates field with passed amount" do
        fetch_result = client.with_base("USD").for_rates(%w[EUR SEK]).at("2007-09-16").fetch
        convert_result = client.with_base("USD")
                               .for_rates(%w[EUR SEK])
                               .at("2007-09-16")
                               .convert(20)
        expect(convert_result).to be_a(ECBExchangeRatesApi::Result)

        expect(convert_result.rates).to be_a(HashWithIndifferentAccess)
        expect(convert_result.date).to be_a(String)
        expect(convert_result.base).to be_a(String)
        rates = fetch_result.rates.values.map { |v| v * 20 }
        expect(convert_result.rates.values).to eq rates
      end
    end
  end
end
