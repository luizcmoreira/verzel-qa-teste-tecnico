# language: pt
@quantidade
Funcionalidade: Limite de 5 unidades por produto
  Como dono da Verzel Store
  Quero limitar cada produto a no máximo 5 unidades por pedido
  Para que a regra valha na interface e na API

  @CA10
  Cenário: CT-QTD-01 - Tela permite chegar a 5 unidades e bloqueia o aumento
    Dado que o carrinho contém 4 Bonés Aba Curva
    Quando clico em "+" uma vez
    Então a quantidade passa a ser 5 e o subtotal é R$ 249,50
    E vejo a mensagem "Limite de 5 unidades por produto."
    E o botão "+" fica desabilitado

  @CA10
  Cenário: CT-QTD-02 - Vitrine bloqueia adicionar um produto que já está no limite
    Dado que o carrinho contém 5 unidades de Camiseta Essencial
    Quando abro a lista de produtos
    Então o botão "Adicionar ao carrinho" da Camiseta Essencial fica desabilitado
    E vejo a mensagem "Limite de 5 unidades atingido."

  @CA10 @api
  Esquema do Cenário: CT-QTD-03 - API recusa mais de 5 unidades no cálculo do carrinho
    Dado que o produto P001 (Camiseta Essencial) existe no catálogo
    Quando envio POST /api/carrinho/calcular com <quantidade> unidades do produto P001
    Então a resposta tem status HTTP 422
    E o código do erro é "QUANTIDADE_MAXIMA_EXCEDIDA"

    Exemplos:
      | quantidade |
      | 6          |
      | 100        |
      | 1000       |

  @CA10 @api
  Cenário: CT-QTD-04 - API recusa mais de 5 unidades ao confirmar o pedido
    Dado que o produto P001 (Camiseta Essencial) existe no catálogo
    Quando envio POST /api/pedidos com dados de cliente válidos e 6 unidades do produto P001
    Então a resposta tem status HTTP 422
    E o código do erro é "QUANTIDADE_MAXIMA_EXCEDIDA"
    E nenhum número de pedido é gerado

  @CA10 @api
  Cenário: CT-QTD-05 - API aceita exatamente 5 unidades do mesmo produto
    Dado que o produto P001 (Camiseta Essencial) existe no catálogo
    Quando envio POST /api/carrinho/calcular com 5 unidades do produto P001
    Então a resposta tem status HTTP 200
    E o subtotal é 299,50, o frete é 0 e o total é 299,50