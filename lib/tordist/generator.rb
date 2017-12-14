class Tordist::Generator

  def initialize(clearing_id)
    @clearing_id = clearing_id
  end

  def generate(transactions)
    @transactions = transactions
    tordist_string = header
    tordist_string = tordist_string + body
  end

  def header
    return fill_with_chars(92, "H#{header_date}#{fill_with_chars(5, @clearing_id, :preceding, "0")}TORDISTM", :following, " ")+"\r\n"
  end

  def body
    body_string = ""
    @transactions.each do |transaction|
      @transaction = transaction
      body_string = body_string + "#{type}#{symbol}#{@transaction.broker_alias_code}#{client_digit}#{quantity}#{price}#{@transaction.side}#{liquidation_portfolio}#{nil_user}#{client}#{client_digit}#{liquidation_type}#{bvmf}#{increase_percentage}#{deadline}#{order_number}#{broker}\r\n"
    end
    return body_string
  end

  protected

  def header_date
    @transactions.first.date.strftime("%d/%m/%Y")
  end

  def symbol
    fill_with_chars(12, @transaction.symbol, :following, " ")
  end

  def quantity
    fill_with_chars(12, @transaction.quantity.abs.to_i.to_s, :preceding, "0")
  end

  def type
    "B"
  end

  def client_digit
    "0"
  end

  def price
    fill_with_chars(11, "", :preceding, "0")
  end

  def liquidation_portfolio
    "216"
  end

  def nil_user
    fill_with_chars(5, "", :following, "0")
  end

  def client
    fill_with_chars(9, "", :following, "0")
  end

  def client_digit
    fill_with_chars(1, "", :following, "0")
  end

  def liquidation_type
    "C"
  end

  def bvmf
    fill_with_chars(2, "1", :following, " ")
  end

  def increase_percentage
    fill_with_chars(12, "+", :following, "0")
  end

  def deadline
    fill_with_chars(4, "", :following, "0")
  end

  def order_number
    fill_with_chars(9, "", :following, "0")
  end

  def broker
    fill_with_chars(5, @transaction.broker, :preceding, "0")
  end

  def fill_with_chars(total_size, text, direction, char)
    size = total_size - text.size
    char_text = ""
    for i in 1..size
      char_text = char_text + char
    end
    if (direction == :following)
      return text + char_text
    elsif (direction == :preceding)
      return char_text + text
    end
  end
end