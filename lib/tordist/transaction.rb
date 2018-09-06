require 'attr_extras'

class Tordist::Transaction
  vattr_initialize :row

  def date
    @row[:date]
  end

  def broker
    @row[:broker]
  end

  def broker_alias_code
    @row[:broker_alias_code]
  end
  
  def side
    @row[:side]
  end
  
  def quantity
    @row[:quantity]
  end
  
  def price
    @row[:price]
  end

  def symbol
    @row[:symbol]
  end
end