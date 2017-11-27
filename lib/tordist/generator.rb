class Tordist::Generator

  def generate(transactions)
    @transactions = transactions
    tordist_string = header
    tordist_string = tordist_string + body
  end

  def header
    return "H#{header_date}#{header_broker}TORDISTM\n"
  end

  def body
    # BBEEF3       0783382000000000680000000000000V216044400001809257C1 +000000000000000         
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

  def header_broker
    @transactions.first.broker
  end

  def symbol
    symbol_text = @transaction.symbol
    remaining_chars = ""
    field_size = 12
    remaining_chars_size = field_size - @transaction.symbol.size
    for i in 1..remaining_chars_size
       remaining_chars = remaining_chars + " "
    end

    symbol_text = symbol_text + remaining_chars

  end

  def quantity
    quantity_text = @transaction.quantity.to_i.to_s 
    remaining_chars = ""
    field_size = 12
    remaining_chars_size = field_size - @transaction.quantity.to_i.to_s.size
    for i in 0..remaining_chars_size
       remaining_chars = remaining_chars + "0"
    end

    quantity_text = remaining_chars + quantity_text
  end

  def type
    "B"
  end

  def client_digit
    "0"
  end

  def price
    "0000000000"
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



end