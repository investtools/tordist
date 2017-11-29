require "spec_helper"
require "date"

describe Tordist::Generator do

  describe "#generate" do
    before do
      @header     = "H23/11/201700114TORDISTM                                                                    "
      @first_line = "BPETR4       0793929000000000100000000000000C216000000000000000C1 +0000000000000000000000000114"

      @transactions = []

      @clearing_id = "00114"
      @transactions << Tordist::Transaction.new({
        symbol: "PETR4",
        date: Date.parse('2017-11-23'),
        broker: "0114",
        side: "C",
        quantity: 1000.0,
        price: 10.0,
        broker_alias_code: "0793929"
      })

      @transactions << Tordist::Transaction.new({
        symbol: "BBAS3",
        date: Date.parse('2017-11-23'),
        broker: "0114",
        side: "V",
        quantity: -1000.0,
        price: 10.0,
        broker_alias_code: "0797700"
      })
    end

    it "should generates txt with header" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n").first).to eq @header
      expect(tordist_text.split("\n").first.size).to eq 92
    end

    it "should generates type properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][0]).to eq "B"
    end

    it "should generates symbol properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][1..12]).to eq "PETR4       "
    end

    it "should generates symbol properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][13..19]).to eq "0793929"
    end

    it "should generates client_digit properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][20..20]).to eq "0"
    end

    it "should generates quantity properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][21..32]).to eq "000000001000"
    end
    
    it "should generates negative quantity properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[2][21..32]).to eq "000000001000"
    end

    it "should generates price properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][33..43]).to eq "00000000000"
    end

    it "should generates side properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][44..44]).to eq "C"
      expect(tordist_text.split("\n")[2][44..44]).to eq "V"
    end

    it "should generates liquidation_portfolio properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][45..47]).to eq "216"
    end

    it "should generate user properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][48..52]).to eq "00000"
    end

    it "should generate client properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][53..61]).to eq "000000000"
    end

    it "should generate client digit properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][62]).to eq "0"
    end

    it "should generate liquidation_type properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][63]).to eq "C"
    end

    it "should generate market properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][64..65]).to eq "1 "
    end

    it "should generate increase percentage properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][66..77]).to eq "+00000000000"
    end

    it "should generate deadline properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][78..81]).to eq "0000"
    end

    it "should generate order number properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][82..90]).to eq "000000000"
    end

    it "should generate broker properly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1][91..95]).to eq "0114"
    end

    it "should have 95 char positions" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1].length).to eq 95
      expect(tordist_text.split("\n")[2].length).to eq 95
    end

    it "should generate first line correctly" do
      tordist_text = Tordist::Generator.new(@clearing_id).generate(@transactions)
      expect(tordist_text.split("\n")[1]).to eq @first_line
    end

  end
end
