# frozen_string_literal: true

RSpec.describe ECBExchangeRatesApi::Result do
  subject(:result) { described_class.new(params) }

  describe "#data" do
    context "when input data is invalid" do
      let(:params) { "invalid params" }

      it "returns empty data" do
        expect(result.to_h).to eq({})
      end
    end

    context "when input data is valid" do
      let(:params) { { name: "test" } }

      it "parses data correctly" do
        expect(result[:name]).to eq "test"
      end

      it "adds getters for data" do
        expect(result.name).to eq "test"
      end
    end
  end
end
