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
    return fill_with_chars(92, "H#{header_date}#{@clearing_id}TORDISTM", :following, " ")+"\n"
  end

  def body
    body_string = ""
    @transactions.each do |transaction|
      @transaction = transaction
      body_string = body_string + "#{type}#{symbol}#{@transaction.broker_alias_code}#{client_digit}#{quantity}#{price}#{@transaction.side}#{liquidation_portfolio}#{nil_user}#{liquidation_type}#{bvmf}#{nil_last_fields}#{@transaction.broker}\n"
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
    fill_with_chars(12, @transaction.quantity.to_i.to_s, :preceding, "0")
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
    "000000000000000"
  end

  def liquidation_type
    "C"
  end

  def bvmf
    "1"
  end

  def nil_last_fields
   " +000000000000000"
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