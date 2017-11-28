require "spec_helper"
require "date"

describe Tordist::Generator do

  describe "#generate" do
    before do
      @transactions = []

      @clearing_id = "00114"
      @transactions << Tordist::Transaction.new({
        symbol: "PETR4",
        date: Date.parse('2017-11-23'),
        broker: "00114",
        side: "C",
        quantity: 1000.0,
        price: 10.0,
        broker_alias_code: "0793929"
      })

      @transactions << Tordist::Transaction.new({
        symbol: "BBAS3",
        date: Date.parse('2017-11-23'),
        broker: "00114",
        side: "C",
        quantity: 1000.0,
        price: 10.0,
        broker_alias_code: "0797700"
      })
    end

    it "should generates txt with header" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n").first).to eq "H23/11/201700114TORDISTM"
    end

    it "should generates txt with body" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n").last).to eq "BBBAS3       0797700000000000010000000000000C216000000000000000C1 +00000000000000000114"
    end

    it "should generates txt with properly broker_alias_code" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1]).to eq "BPETR4       0793929000000000010000000000000C216000000000000000C1 +00000000000000000114"
    end
  end
end
