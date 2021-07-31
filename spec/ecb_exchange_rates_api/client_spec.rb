# frozen_string_literal: true

RSpec.describe ECBExchangeRatesApi::Client do
  subject(:client) { described_class.new(access_key: access_key, secured: secured) }
  let(:access_key) { ENV["TEST_ACCESS_TOKEN"] }
  let(:secured) { false }

  describe "#fetch", :vcr do
    context "with unsecured protocol" do
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

      context "when specific symbols were requested" do
        it "returns result instance with specified symbols" do
          expected_base = "EUR"
          expected_currencies = %w[DJF NIO DZD]

          result = client.for_rates(expected_currencies).fetch
          expect(result).to be_a(ECBExchangeRatesApi::Result)

          expect(result.rates).to be_a(HashWithIndifferentAccess)
          expect(result.date).to be_a(String)
          expect(result.base).to be_a(String)

          expect(result.rates.keys).to eq expected_currencies
          expect(result.base).to eq expected_base
        end

        context "and some of symbols is invalid" do
          it "returns result instance with specified symbols" do
            expected_base = "EUR"
            currencies = %w[DJF NIO DZD BBB]
            expected_currencies = %w[DJF NIO DZD]

            result = client.for_rates(currencies).fetch
            expect(result).to be_a(ECBExchangeRatesApi::Result)

            expect(result.rates).to be_a(HashWithIndifferentAccess)
            expect(result.date).to be_a(String)
            expect(result.base).to be_a(String)

            expect(result.rates.keys).to eq expected_currencies
            expect(result.base).to eq expected_base
          end
        end
      end

      context "historical rates are requested" do
        it "returns result instance for specific date" do
          expected_base = "GBP"
          expected_currencies_list = %w[USD CAD EUR]
          expected_at = "2013-12-24"

          result = described_class.new(access_key: access_key) do |client|
            client.with_base expected_base
            client.for_rates expected_currencies_list
            client.at expected_at
          end.fetch

          expect(result).to be_a(ECBExchangeRatesApi::Result)

          expect(result.rates).to be_a(HashWithIndifferentAccess)
          expect(result.date).to be_a(String)
          expect(result.base).to be_a(String)

          expect(result.rates).to match(hash_including(*expected_currencies_list))
          expect(result.base).to eq expected_base
          expect(result.date).to eq expected_at
          expect(result.historical).to be_truthy
        end
      end

      context "when time series are requested" do
        it "returns results for all specified dates" do
          expected_currencies_list = %w[USD SEK]
          expected_start_date = "2013-12-24"
          expected_end_date = "2013-12-26"
          expected_rates_list = {
            "2013-12-24" => hash_including(*expected_currencies_list),
            "2013-12-25" => hash_including(*expected_currencies_list),
            "2013-12-26" => hash_including(*expected_currencies_list)
          }

          result = described_class.new(access_key: access_key) do |client|
            client.for_rates expected_currencies_list
            client.timeseries expected_start_date, expected_end_date
          end.fetch

          expect(result.timeseries).to be_truthy
          expect(result.start_date).to eq expected_start_date
          expect(result.end_date).to eq expected_end_date
          expect(result.rates).to match(expected_rates_list)
        end
      end

      context "when conversion is requested" do
        it "returns result for converted amount" do
          expected_from = "USD"
          expected_to = "EUR"
          expected_amount = 100

          result = described_class.new(access_key: access_key)
                                  .convert(expected_from, expected_to, expected_amount)
                                  .fetch

          expect(result.query[:from]).to eq expected_from
          expect(result.query[:to]).to eq expected_to
          expect(result.query[:amount]).to eq expected_amount

          expect(result.info.keys).to match %w[timestamp rate]
          expect(result.result).to be_a(Float)
        end

        context "for the specific date" do
          it "returns result for converted amount" do
            expected_from = "UAH"
            expected_to = "USD"
            expected_amount = 100
            expected_at = "2020-07-28"

            result = described_class.new(access_key: access_key)
                                    .convert(expected_from, expected_to, expected_amount)
                                    .at(expected_at)
                                    .fetch

            expect(result.query[:from]).to eq expected_from
            expect(result.query[:to]).to eq expected_to
            expect(result.query[:amount]).to eq expected_amount

            expect(result.date).to eq "2020-07-28"
            expect(result.info.keys).to match %w[timestamp rate]
            expect(result.result).to eq 3.6101 # should not be changed for historical data
          end
        end
      end

      context "when rates are requested with fluctuation" do
        it "returns fluctuation between dates for requested rates" do
          expected_base = "AUD"
          expected_currencies_list = %w[GBP SEK]
          expected_from = "2014-09-01"
          expected_to = "2014-09-05"

          result = described_class.new(access_key: access_key) do |client|
            client.with_base expected_base
            client.for_rates expected_currencies_list
            client.timeseries expected_from, expected_to
            client.fluctuation
          end.fetch

          expect(result.fluctuation).to be_truthy
          expect(result.start_date).to eq expected_from
          expect(result.end_date).to eq expected_to
          expect(result.base).to eq expected_base
          expect(result.rates.keys).to eq expected_currencies_list

          result.rates.each do |_, rate|
            expect(rate.keys).to eq %w[start_rate end_rate change change_pct]
          end
        end
      end
    end
  end
end
