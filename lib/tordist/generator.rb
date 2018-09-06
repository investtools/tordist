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
    "H#{header_date}#{@clearing_id.rjust(5,'0')}#{file_name}#{distribution_type}".ljust(92," ") +"\r\n"
  end

  def body
    body_string = ""
    @transactions.each do |transaction|
      @transaction = transaction
      body_string = body_string + "#{type}#{symbol}#{@transaction.broker_alias_code.rjust(7,'0')}#{client_digit}#{quantity}#{price}#{@transaction.side}#{liquidation_portfolio}#{nil_user}#{client}#{client_digit}#{liquidation_type}#{bvmf}#{increase_percentage}#{deadline}#{order_number}#{broker}\r\n"
    end
    return body_string
  end

  protected
  
  def file_name
    'TORDIST'
  end
  
  def distribution_type
    # 05 –	TIPO DA DISTRIBUIÇÃO
    # “P” – PERCENTUAL, “M” – PREÇO MÉDIO POR LOTE, “D” – PREÇO DIGITADO, “O” – PREÇO MÉDIO POR ORDEM, “R” – PREÇO DIGITADO POR ORDEM.
    'M'
  end

  def header_date
    @transactions.first.date.strftime("%d/%m/%Y")
  end

  def symbol
    @transaction.symbol.ljust(12, ' ')
  end

  def quantity
    @transaction.quantity.abs.to_i.to_s.rjust(12, '0')
  end

  def type
    # FIXO “B”
    "B"
  end

  def client_digit
    "0"
  end

  def price
    # SOMENTE PARA TIPO DE DISTRIBUIÇÃO "D"
    ''.rjust(11,'0')
  end

  def liquidation_portfolio
    "216"
  end

  def nil_user
    ''.rjust(5,"0")
  end

  def client
    ''.rjust(9,'0')
  end

  def client_digit
    '0'
  end

  def liquidation_type
    "C"
  end

  def bvmf
    '1 '
  end

  def increase_percentage
    '+'.ljust(12,'0')
  end

  def deadline
    ''.rjust(4,'0')
  end

  def order_number
    ''.rjust(9,'0')
  end

  def broker
    @transaction.broker.rjust(5,'0')
  end

end
