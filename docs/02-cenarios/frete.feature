# language: pt
@frete
Funcionalidade: Cálculo de frete e frete grátis no carrinho
  Como cliente da Verzel Store
  Quero ganhar frete grátis em compras maiores
  Para pagar menos nas minhas compras

  @CA07
  Cenário: CT-FRETE-01 - Frete fixo é cobrado quando o subtotal é abaixo de R$ 200,00
    Dado que o carrinho contém 1 Camiseta Essencial (subtotal R$ 59,90)
    Quando abro o carrinho
    Então o subtotal é R$ 59,90, o desconto é R$ 0,00, o frete é R$ 19,90 e o total é R$ 79,80
    E vejo a mensagem "Faltam R$ 140,10 para o frete grátis."

  @CA06
  Cenário: CT-FRETE-02 - Frete grátis é aplicado quando o subtotal é exatamente R$ 200,00
    Dado que o carrinho contém 2 Mochilas Urbanas 20L (subtotal R$ 200,00)
    Quando abro o carrinho
    Então o subtotal é R$ 200,00, o desconto é R$ 0,00, o frete é R$ 0,00 e o total é R$ 200,00

  @CA06
  Cenário: CT-FRETE-03 - Frete grátis é aplicado quando o subtotal é acima de R$ 200,00
    Dado que o carrinho contém 1 Tênis Casual Urbano e 1 Kit 3 Pares de Meias (subtotal R$ 219,80)
    Quando abro o carrinho
    Então o frete aparece como "Grátis"
    E o subtotal é R$ 219,80, o desconto é R$ 0,00 e o total é R$ 219,80

  @CA07
  Cenário: CT-FRETE-04 - Subtotal logo abaixo de R$ 200,00 ainda cobra frete e informa o que falta
    Dado que o carrinho contém 1 Calça Jeans Slim e 1 Camiseta Essencial (subtotal R$ 199,80)
    Quando abro o carrinho
    Então o frete é R$ 19,90 e o total é R$ 219,70
    E vejo a mensagem "Faltam R$ 0,20 para o frete grátis."

  @CA08
  Cenário: CT-FRETE-05 - Frete grátis considera o subtotal antes do desconto do cupom
    Dado que o carrinho contém 1 Tênis Casual Urbano e 1 Kit 3 Pares de Meias (subtotal R$ 219,80)
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto é R$ 21,98 e o total é R$ 197,82
    E o frete continua "Grátis", mesmo com o total abaixo de R$ 200,00

  @CA08
  Cenário: CT-FRETE-06 - Cupom não torna grátis um frete cobrado por subtotal abaixo de R$ 200,00
    Dado que o carrinho contém 5 Kits 3 Pares de Meias e 1 Boné Aba Curva (subtotal R$ 199,40)
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto é R$ 19,94, o frete é R$ 19,90 e o total é R$ 199,36
    E vejo a mensagem "Faltam R$ 0,60 para o frete grátis."

  @CA09
  Cenário: CT-FRETE-07 - O desconto do cupom não incide sobre o frete
    Dado que o carrinho contém 1 Camiseta Essencial (subtotal R$ 59,90)
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto é R$ 5,99, calculado só sobre o subtotal
    E o frete continua R$ 19,90 e o total é R$ 73,81

  @CA06 @CA08
  Cenário: CT-FRETE-08 - Subtotal exatamente R$ 200,00 com cupom mantém frete grátis
    # Valores esperados calculados pela fórmula da doc: 200,00 - 20,00 + 0,00
    Dado que o carrinho contém 4 Garrafas Térmicas 750ml (subtotal R$ 200,00)
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto é R$ 20,00 e o frete é R$ 0,00
    E o total é R$ 180,00