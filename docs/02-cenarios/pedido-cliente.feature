# language: pt
@pedido-cliente
Funcionalidade: Dados do cliente e confirmação do pedido
  Como cliente da Verzel Store
  Quero informar meus dados de entrega e confirmar o pedido
  Para receber minha compra e pagar na entrega

  @regra-existente
  Cenário: CT-PED-01 - Pedido é confirmado com dados válidos
    Dado que o carrinho contém 1 Camiseta Essencial
    E estou na tela "Finalizar compra"
    Quando preencho nome "Maria Moraes", e-mail "maria@exemplo.com" e CEP "01310-100" e clico em "Confirmar pedido"
    Então vejo "Pedido confirmado" e um número de pedido no formato VZ-000000
    E vejo a mensagem "Obrigado, Maria. Seu pedido foi registrado e o pagamento será feito na entrega."
    E o resumo mostra subtotal R$ 59,90, desconto R$ 0,00, frete R$ 19,90 e total R$ 79,80

  @regra-existente
  Cenário: CT-PED-02 - Nome sem sobrenome é recusado
    Dado que o carrinho contém 1 Camiseta Essencial
    E estou na tela "Finalizar compra"
    Quando preencho nome "Maria", e-mail "maria@exemplo.com" e CEP "01310-100" e clico em "Confirmar pedido"
    Então vejo a mensagem "Informe nome e sobrenome."
    E o pedido não é confirmado

  @regra-existente
  Cenário: CT-PED-03 - E-mail sem arroba é recusado
    Dado que o carrinho contém 1 Camiseta Essencial
    E estou na tela "Finalizar compra"
    Quando preencho nome "João Joanio", e-mail "joao.exemplo.com" e CEP "01310-100" e clico em "Confirmar pedido"
    Então vejo a mensagem "Informe um e-mail válido."
    E o pedido não é confirmado

  @regra-existente
  Cenário: CT-PED-04 - E-mail com número no domínio é aceito
    Dado que o carrinho contém 1 Camiseta Essencial
    E estou na tela "Finalizar compra"
    Quando preencho nome "João Joanio", e-mail "joao.joanio@exemplo2.com" e CEP "01310-100" e clico em "Confirmar pedido"
    Então vejo "Pedido confirmado"

  @regra-existente
  Esquema do Cenário: CT-PED-05 - CEP com 8 dígitos, com ou sem hífen, é aceito
    Dado que o carrinho contém 1 Camiseta Essencial
    E estou na tela "Finalizar compra"
    Quando preencho nome "Claudio Castrinho", e-mail "claudio@exemplo3.com" e CEP "<cep>" e clico em "Confirmar pedido"
    Então vejo "Pedido confirmado"

    Exemplos:
      | cep       |
      | 01310-100 |
      | 01310100  |
      | 12345678  |

  @regra-existente
  Esquema do Cenário: CT-PED-06 - CEP fora do formato é recusado
    Dado que o carrinho contém 1 Camiseta Essencial
    E estou na tela "Finalizar compra"
    Quando preencho nome "Mateus Matias", e-mail "mateus@exemplo4.com" e CEP "<cep>" e clico em "Confirmar pedido"
    Então vejo a mensagem "Informe um CEP com 8 dígitos."
    E o pedido não é confirmado

    Exemplos:
      | cep        | observação                  |
      | 0131010    | 7 dígitos                   |
      | 12-345678  | hífen na 3ª posição         |
      | 123-45678  | hífen na 4ª posição         |
      | 1234567-8  | hífen na 8ª posição         |
      | 12345678-  | hífen no final              |
      | -12345678  | hífen no início             |
      | 12345-678- | hífen certo e outro no fim  |

  @regra-existente
  Cenário: CT-PED-07 - Pagamento é feito na entrega, sem etapa de pagamento online
    Dado que o carrinho contém 1 Camiseta Essencial
    Quando abro a tela "Finalizar compra"
    Então vejo o texto "O pagamento é feito na entrega."
    E a tela só pede nome, e-mail e CEP

  @CA01
  Cenário: CT-PED-08 - Pedido confirmado leva o desconto do cupom
    Dado que o carrinho contém 1 Boné Aba Curva
    E o cupom "BEMVINDO10" está aplicado
    E estou na tela "Finalizar compra"
    Quando preencho nome "João Joanio", e-mail "joao.joanio@exemplo2.com" e CEP "01310-100" e clico em "Confirmar pedido"
    Então vejo "Pedido confirmado"
    E o resumo mostra subtotal R$ 49,90, desconto R$ 4,99, frete R$ 19,90 e total R$ 64,81

  @regra-existente @api
  Cenário: CT-PED-09 - API lista todos os campos inválidos do cliente de uma vez
    Dado que o produto P001 (Camiseta Essencial) existe no catálogo
    Quando envio POST /api/pedidos com nome "Maria", e-mail "maria.exemplo.com" e CEP "123"
    Então a resposta tem status HTTP 422 e o código do erro é "DADOS_INVALIDOS"
    E "campos" lista "cliente.nome", "cliente.email" e "cliente.cep" com suas mensagens

  @regra-existente @api
  Cenário: CT-PED-10 - API confirma o pedido e normaliza o CEP
    Dado que o produto P001 (Camiseta Essencial) existe no catálogo
    Quando envio POST /api/pedidos com nome "Maria Silva", e-mail "maria@exemplo.com", CEP "01310-100" e 1 unidade de P001
    Então a resposta tem status HTTP 201 e um número de pedido no formato VZ-000000
    E o CEP retornado é "01310100", sem hífen
