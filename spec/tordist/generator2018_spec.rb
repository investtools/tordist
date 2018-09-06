require "spec_helper"
require "date"

describe Tordist::Generator2018 do

  let(:carrying_broker_id) { '114' }
  let(:generator) { Tordist::Generator2018.new(carrying_broker_id) }
  
  describe "#generate" do
    before do
      @transactions = []
      @transactions << Tordist::Transaction.new({
        symbol: "PETR4",
        date: Date.parse('2017-11-23'),
        broker: "0114",
        side: "C",
        quantity: 6789.0,
        price: 10.0,
        broker_alias_code: "793929"
      })
      @transactions << Tordist::Transaction.new({
        symbol: "BBAS3",
        date: Date.parse('2017-11-23'),
        broker: "0114",
        side: "V",
        quantity: -3456.0,
        price: 10.0,
        broker_alias_code: "797700"
      })
    end
    
    it "should generates type properly" do
      tordist_text = generator.generate(@transactions)
      #puts tordist_text.gsub("\n", "\n:")
      expect(tordist_text.split("\r\n")[1][0]).to eq "B"
    end
    
    it "should generates symbol properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][1..12]).to eq "PETR4       "
    end
    
    it "should generates broker_alias_code properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][13..19]).to eq "0793929"
    end
    
    it "should generates client_digit properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][20..20]).to eq "0"
    end
    
    it "should generates quantity properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][21..32]).to eq "000000006789"
    end
    
    it "should generates negative quantity properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[2][21..32]).to eq "000000003456"
    end
    
    it "should generates price properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][33..43]).to eq "00000000000"
    end
    
    it "should generates side properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][44..44]).to eq "C"
      expect(tordist_text.split("\r\n")[2][44..44]).to eq "V"
    end
    
    it "should generates liquidation_portfolio properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][45..47]).to eq "216"
    end
    
    it "should generate user properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][48..52]).to eq "00000"
    end
    
    it "should generate client properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][53..61]).to eq "000000000"
    end
    
    it "should generate client digit properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][62]).to eq "0"
    end
    
    it "should generate liquidation_type properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][63]).to eq "C"
    end
    
    it "should generate market properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][64..65]).to eq "1 "
    end
    
    it "should generate increase percentage properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][66..77]).to eq "+00000000000"
    end
    
    it "should generate deadline properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][78..81]).to eq "0000"
    end
    
    it "should generate order number properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][82..90]).to eq "000000000"
    end
    
    it "should generate exec pct properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][91..102]).to eq "+00000000000"
    end
    
    it "should generate broker properly" do
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][103..107]).to eq "00114"
    end
    
    it "should runs in time" do
      20000.times do |i|
        @transactions << Tordist::Transaction.new({
          symbol: "BBAS3",
          date: Date.parse('2017-11-23'),
          broker: "0114",
          side: "V",
          quantity: i+100,
          price: 10.0,
          broker_alias_code: "797700"
        })
      end
      tordist_text = generator.generate(@transactions)
      expect(tordist_text.split("\r\n")[1][103..107]).to eq "00114"
    end
  end
  
end
