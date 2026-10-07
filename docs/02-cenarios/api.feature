# language: pt
@api
Funcionalidade: API da Verzel Store
  Como consumidor da API da Verzel Store
  Quero respostas e erros previsíveis
  Para integrar com segurança

  Cenário: CT-API-01 - Listar todos os produtos
    # Ainda não executado
    Quando envio GET /api/produtos
    Então a resposta tem status HTTP 200
    E a lista traz os 8 produtos de P001 a P008, com id, nome, descricao, categoria e preco

  Cenário: CT-API-02 - Consultar um produto existente
    # Ainda não executado
    Quando envio GET /api/produtos/P001
    Então a resposta tem status HTTP 200
    E o produto é "Camiseta Essencial" com preço 59.9

  Cenário: CT-API-03 - Consultar um produto que não existe
    Quando envio GET /api/produtos/P999
    Então a resposta tem status HTTP 404
    E o código do erro é "PRODUTO_NAO_ENCONTRADO"

  Cenário: CT-API-04 - Acessar uma rota que não existe
    Quando envio GET /api/rota-inexistente
    Então a resposta tem status HTTP 404
    E o código do erro é "ROTA_NAO_ENCONTRADA"

  Cenário: CT-API-05 - Usar um método HTTP não permitido na rota
    Quando envio GET /api/carrinho/calcular
    Então a resposta tem status HTTP 405
    E o código do erro é "METODO_NAO_PERMITIDO"

  Cenário: CT-API-06 - Enviar um corpo que não é JSON válido
    Quando envio POST /api/carrinho/calcular com o corpo "{itens:"
    Então a resposta tem status HTTP 400
    E o código do erro é "JSON_INVALIDO"

  Cenário: CT-API-07 - Enviar a lista de itens vazia
    Quando envio POST /api/carrinho/calcular com "itens" vazio
    Então a resposta tem status HTTP 422
    E o código do erro é "ITENS_OBRIGATORIOS" e o campo é "itens"

  Cenário: CT-API-08 - Enviar um item que não é um objeto
    Quando envio POST /api/carrinho/calcular com "itens" igual a ["P001"]
    Então a resposta tem status HTTP 422
    E o código do erro é "ITEM_INVALIDO" e o campo é "itens[0]"

  Cenário: CT-API-09 - Enviar um item com produto que não existe
    Quando envio POST /api/carrinho/calcular com 1 unidade do produto P999
    Então a resposta tem status HTTP 422
    E o código do erro é "PRODUTO_NAO_ENCONTRADO" e o campo é "itens[0].produtoId"

  Cenário: CT-API-10 - Enviar o mesmo produto duas vezes na lista
    Quando envio POST /api/carrinho/calcular com P001 na quantidade 1 e P001 novamente na quantidade 2
    Então a resposta tem status HTTP 422
    E o código do erro é "ITEM_DUPLICADO" e o campo é "itens[1].produtoId"

  Esquema do Cenário: CT-API-11 - Enviar quantidade que não é um inteiro maior ou igual a 1
    Quando envio POST /api/carrinho/calcular com o produto P001 e quantidade <valor>
    Então a resposta tem status HTTP 422
    E o código do erro é "QUANTIDADE_INVALIDA" e o campo é "itens[0].quantidade"

    Exemplos:
      | valor | observação        |
      | 0     | zero              |
      | -1    | negativo          |
      | 1.5   | decimal           |
      | "2"   | número como texto |
      | null  | nulo              |

  @CA03
  Cenário: CT-API-12 - Cupom inexistente no cálculo não gera erro e não dá desconto
    Quando envio POST /api/carrinho/calcular com 1 unidade de P001 e o cupom "CUPOMFALSO"
    Então a resposta tem status HTTP 200
    E "cupom.aplicado" é false e "cupom.mensagem" é "Cupom inválido."
    E o desconto é 0 e o total é 79.8

  @CA02
  Cenário: CT-API-13 - Cupom em minúsculo e com espaços é normalizado no cálculo
    Quando envio POST /api/carrinho/calcular com 1 unidade de P001 e o cupom "  bemvindo10  "
    Então a resposta tem status HTTP 200
    E "cupom.codigo" é "BEMVINDO10" e "cupom.aplicado" é true
    E o desconto é 5.99 e o total é 73.81

  @CA03
  Cenário: CT-API-14 - Cupom inexistente ao confirmar o pedido gera erro
    Quando envio POST /api/pedidos com dados de cliente válidos, 1 unidade de P001 e o cupom "CUPOMFALSO"
    Então a resposta tem status HTTP 422
    E o código do erro é "CUPOM_INVALIDO" e o campo é "cupom"

  @CA04
  Cenário: CT-API-15 - Cupom expirado ao confirmar o pedido gera erro
    Quando envio POST /api/pedidos com dados de cliente válidos, 1 unidade de P001 e o cupom "VERAO2026"
    Então a resposta tem status HTTP 422
    E o código do erro é "CUPOM_EXPIRADO" e o campo é "cupom"