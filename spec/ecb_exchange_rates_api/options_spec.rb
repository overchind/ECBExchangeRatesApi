# frozen_string_literal: true

RSpec.describe ECBExchangeRatesApi::Options do
  subject(:options) { described_class.new(access_key: access_key, secured: secured) }
  let(:access_key) { "ACCESS_KEY" }
  let(:secured) { false }

  shared_examples "computes date attribute writers" do
    subject(:assign_date) { options.send("#{accessor}=", date) }

    context "when date is an instance of the DateTime" do
      let(:date) { Time.new }
      let(:formatted_date) { date.strftime("%Y-%m-%d") }

      it "assigns formatted date" do
        assign_date
        expect(options.send(accessor)).to eq formatted_date
      end
    end

    context "when date is an instance of the String" do
      context "when date is correctly formatted" do
        let(:date) { "2015-11-12" }
        it "assigns date" do
          assign_date
          expect(options.send(accessor)).to eq date
        end

        it "does not raise errors" do
          expect { assign_date }.not_to raise_error
        end
      end

      context "when date is invalid" do
        %w[invalid_string 2011-34-45].each do |date|
          let(:date) { date }
          it "raises invalid date format error with #{date} date" do
            expect { assign_date }.to raise_error(ECBExchangeRatesApi::InvalidDateFormatError)
          end
        end
      end
    end
  end

  shared_examples "computes valid currency symbol" do
    it "assigns expected currency symbol" do
      assign_currency
      expect(options.send(accessor)).to eq expected_result
    end
  end

  describe "#start_date=" do
    let(:accessor) { :start_date }
    it_behaves_like "computes date attribute writers"
  end

  describe "#end_date" do
    let(:accessor) { :end_date }
    it_behaves_like "computes date attribute writers"
  end

  describe "#date" do
    let(:accessor) { :date }
    it_behaves_like "computes date attribute writers"
  end

  describe "#base=" do
    let(:accessor) { :base }
    let(:assign_currency) { options.send("#{accessor}=", currency) }

    context "when currency is valid" do
      let(:currency) { "USD" }
      let(:expected_result) { "USD" }

      it_behaves_like "computes valid currency symbol"

      context "when currency should be formatted" do
        let(:currency) { "  usd" }

        it_behaves_like "computes valid currency symbol"
      end
    end

    context "when currency is invalid" do
      let(:currency) { "invalid_string" }

      it "raises invalid currency code error" do
        expect { assign_currency }.to raise_error(ECBExchangeRatesApi::InvalidCurrencyCodeError)
      end
    end
  end

  describe "#append_symbol" do
    let(:assign_currency) { options.append_symbol(currency) }
    let(:accessor) { :symbols }

    context "when currency is valid" do
      let(:currency) { "USD" }
      let(:expected_result) { Set.new(["USD"]) }

      it_behaves_like "computes valid currency symbol"

      context "when currency should be formatted" do
        let(:currency) { "  usd" }

        it_behaves_like "computes valid currency symbol"
      end
    end

    context "when currency is invalid" do
      let(:currency) { "invalid_string" }

      it "raises invalid currency code error" do
        expect { assign_currency }.to raise_error(ECBExchangeRatesApi::InvalidCurrencyCodeError)
      end
    end
  end

  describe "#to_params" do
    subject(:options_to_params) { options.to_params }
    let(:start_date) { "2015-11-11" }
    let(:usd_base) { "USD" }
    let(:hash_with_configured_variables) do
      {
        access_key: "ACCESS_KEY",
        start_date: start_date,
        base: usd_base
      }
    end

    before do
      options.start_date = start_date
      options.base = usd_base
    end

    it { is_expected.to eq hash_with_configured_variables }
  end
end
