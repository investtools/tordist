class Tordist::Generator2018 < Tordist::BaseGenerator
  
  def initialize(clearing_id)
    @clearing_id = clearing_id.to_s
    @line_length = 108
    @layout = [
      FixField.new('1 - TIPO DE REGISTRO', 'FIXO B', 'X(01)', 1, 1, default: 'B'),
      StrField.new('2 - CODIGO DE NEGOCIACAO', 'CODIGO DE NEGOCIACAO NA BOVESPA', 'X(12)', 2, 13, prop: :symbol),
      IntField.new('3 - CODIGO DO CLIENTE', '', 'N(7)', 14, 20, prop: :broker_alias_code),
      IntField.new('4 - DIGITO DO CLIENTE', '', 'N(01)', 21, 21, default: 0),
      IntField.new(
        '5 - QUANTIDADE / PERCENTUAL', 
        'PARA TIPO DE DISTRIBUIÇÃO = “D” OU “M” QUANTIDADE DO CLIENTE; PARA TIPO DE DISTRIBUIÇÃO = “P” PERCENTUAL A SER DISTRIBUIDO PARA O CLIENTE.',
        'N(12)', 22, 33, prop: :quantity
      ),
      DecField.new('6 - PRECO DO NEGOCIO', 'SOMENTE PARA TIPO DE DISTRIBUICAO "D"', 'N(09)V02', 34, 44, default: 0),
      StrField.new('7 - NATUREZA DA OPERACAO', '“C” = COMPRA OU “V” = VENDA', 'X(1)', 45, 45, prop: :side),
      IntField.new('8 - CARTEIRA DE LIQUIDACAO', '', 'N(3)', 46, 48, default: 216),
      IntField.new('9 - USUARIO', 'CUSTODIANTE OU USUÁRIO DE ARBITRAGEM', 'N(05)', 49, 53, default: 0),
      IntField.new('10 - CLIENTE', 'CLIENTE NO CUSTODIANTE OU NO USUÁRIO DA ARBITRAGEM', 'N(9)', 54, 62, default: 0),
      IntField.new('11 - DÍGITO DO CLIENTE', 'DÍGITO DO CLIENTE NO CUSTODIANTE OU NO USUÁRIO DA ARBITRAGEM', 'N(1)', 63, 63, default: 0),
      StrField.new('12 - TIPO DE LIQUIDACAO', '“C” = CUSTODIANTE OU “A” = ARBITRAGEM', 'X(1)', 64, 64, default: 'C'),
      StrField.new('13 - BOLSA DO NEGOCIO', '“1 ” = BOVESPA - "5" = SOMA', 'X(2)', 65, 66, default: '1'),
      SigField.new(
        '14 - PERCENTUAL DE ACRÉSCIMO OU REDUÇÃO DO CUSTO DE CLEARING', 
        'A PRIMEIRA POSIÇÃO DEVE CONTER O SINAL DE NEGATIVO PARA DESCONTO E O SINAL DE POSITIVO PARA ACRÉSCIMO. NO CASO DE CUSTO TOTAL UTILIZE SINAL POSITIVO. PARA ASSUMIR O DO CADASTRO DE CLIENTES DO SINACOR, DEIXAR ESTA INFORMAÇÃO EM BRANCO OU PREENCHER COM ZERO',
        'N(04)V08', 67, 78,
        default: 0
      ),
      IntField.new('15 - PRAZO DO TERMO', 'PRAZO DO TERMO. NA AUSÊNCIA DO PRAZO OU NÃO TERMO, PREENCHER COM ZEROS.', 'N(4)', 79, 82, default: 0),
      IntField.new('16 - NUMERO DA ORDEM', 'NUMERO DA ORDEM A SER DISTRIBUIDA', 'N(09)', 83, 91, default: 0),
      SigField.new(
        '17 - PERCENTUAL DE ACRESCIMO OU REDUCAO DO CUSTO DE EXECUCAO',
        'A PRIMEIRA POSIÇÃO DEVE CONTER O SINAL DE NEGATIVO PARA DESCONTO E O SINAL DE POSITIVO PARA ACRÉSCIMO. NO CASO DE CUSTO TOTAL UTILIZE SINAL POSITIVO. PARA ASSUMIR O DO CADASTRO DE CLIENTES DO SINACOR, DEIXAR ESTA INFORMAÇÃO EM BRANCO OU PREENCHER COM ZERO',
        'N(04)V08', 92, 103,
        default: 0
      ),
      IntField.new('18 - CORRETORA ORIGEM', 'CÓDIGO DO PARTICIPANTE ORIGEM DO NEGÓCIO', 'N(05)', 104, 108, prop: :broker)
    ]
  end
  
  def generate(transactions)
    lines = []
    lines << header(transactions)
    transactions.each do |transaction|
      line = @layout.map {|field| field.value(transaction) }.join
      if line.length != @line_length
        raise "line length error: #{line}"
      end
      lines << line
    end
    lines << ''
    lines.join("\r\n")
  end
  
  def header(transactions)
    "H#{header_date(transactions)}#{@clearing_id.rjust(5,'0')}#{file_name}#{distribution_type}".ljust(@line_length," ")
  end
  
  def header_date(transactions)
    transactions.first.date.strftime("%d/%m/%Y")
  end
  
  def file_name
    'TORDIST'
  end
  
  def distribution_type
    'M'
  end
  
  
  
end
