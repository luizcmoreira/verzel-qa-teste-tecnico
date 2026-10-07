# language: pt
@cupom
Funcionalidade: Aplicação de cupom de desconto no carrinho
  Como cliente da Verzel Store
  Quero aplicar um cupom de desconto no carrinho
  Para pagar menos nas minhas compras

  @CA01
  Cenário: CT-CUPOM-01 - Cupom BEMVINDO10 aplica 10% de desconto sobre o subtotal
    Dado que o carrinho contém 1 Camiseta Essencial
    Quando aplico o cupom "BEMVINDO10"
    Então vejo a confirmação "Cupom BEMVINDO10 aplicado."
    E o subtotal é R$ 59,90, o desconto é R$ 5,99, o frete é R$ 19,90 e o total é R$ 73,81

  @CA02
  Esquema do Cenário: CT-CUPOM-02 - Código do cupom não diferencia maiúsculas de minúsculas
    Dado que o carrinho contém 1 Camiseta Essencial
    Quando aplico o cupom "<codigo>"
    Então o cupom BEMVINDO10 é aplicado
    E o desconto é R$ 5,99 e o total é R$ 73,81

    Exemplos:
      | codigo     |
      | bemvindo10 |
      | BemVindo10 |
      | bEMvINDO10 |

  @CA02
  Cenário: CT-CUPOM-03 - Espaços no início e no fim do código são ignorados
    Dado que o carrinho contém 1 Camiseta Essencial
    Quando aplico o cupom "BEMVINDO10" com dois espaços antes e dois espaços depois
    Então o cupom BEMVINDO10 é aplicado
    E o desconto é R$ 5,99 e o total é R$ 73,81

  @CA03
  Cenário: CT-CUPOM-04 - Cupom inexistente não aplica desconto
    Dado que o carrinho contém 1 Camiseta Essencial
    Quando aplico o cupom "CUPOMFALSO"
    Então vejo a mensagem "Cupom inválido."
    E o subtotal é R$ 59,90, o desconto é R$ 0,00, o frete é R$ 19,90 e o total é R$ 79,80

  @CA03 @ambiguidade
  Cenário: CT-CUPOM-05 - Tentar aplicar cupom com o campo vazio
    # A doc não define este caso. Comportamento observado: a tela pede o preenchimento.
    Dado que o carrinho contém 1 Camiseta Essencial
    Quando tento aplicar um cupom com o campo vazio
    Então vejo a mensagem "Informe um cupom."
    E o desconto é R$ 0,00 e o total é R$ 79,80

  @CA04
  Cenário: CT-CUPOM-06 - Cupom expirado não aplica desconto
    Dado que o carrinho contém 1 Camiseta Essencial
    Quando aplico o cupom "VERAO2026"
    Então vejo a mensagem "Cupom expirado."
    E o subtotal é R$ 59,90, o desconto é R$ 0,00, o frete é R$ 19,90 e o total é R$ 79,80

  @CA02 @CA04
  Cenário: CT-CUPOM-07 - Cupom expirado também ignora maiúsculas e minúsculas
    Dado que o carrinho contém 1 Camiseta Essencial
    Quando aplico o cupom "verao2026"
    Então vejo a mensagem "Cupom expirado."
    E o desconto é R$ 0,00 e o total é R$ 79,80

  @CA05
  Cenário: CT-CUPOM-08 - Com um cupom aplicado, não é possível digitar outro
    Dado que o carrinho contém 1 Camiseta Essencial
    E o cupom "BEMVINDO10" está aplicado
    Então o campo para digitar um cupom não é exibido
    E aparece a opção "Remover cupom"

  @CA05
  Cenário: CT-CUPOM-09 - Remover o cupom zera o desconto e permite aplicar de novo
    Dado que o carrinho contém 1 Camiseta Essencial
    E o cupom "BEMVINDO10" está aplicado
    Quando removo o cupom aplicado
    Então o desconto é R$ 0,00 e o total é R$ 79,80
    E o campo para digitar um cupom volta a ser exibido
    Quando aplico o cupom "bemvindo10"
    Então o cupom BEMVINDO10 é aplicado