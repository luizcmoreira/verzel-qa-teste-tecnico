# Evidências

Cada cenário executado em [03-execucao.md](../03-execucao.md) tem aqui o arquivo que comprova o resultado. As evidências dos bugs ficam na raiz desta pasta (prefixo `BUG-`). As demais ficam em `execucao/` (telas) e `execucao/api/` (respostas da API).

## Como as evidências foram geradas

- **Telas:** captura da janela inteira do navegador, com a barra de endereço visível, tiradas em 06/10/2026.
- **API:** resposta completa (status HTTP, headers e body) gravada com `curl -s -i`. Todas as chamadas de cenário podem ser reproduzidas com `./scripts/evidencias-api.sh`, que grava um `.txt` por cenário em `execucao/api/` e indica `OK` ou `DIFF` em relação ao que a documentação manda. Os `DIFF` esperados são os do BUG-002 (CT-QTD-03 e CT-QTD-04).
- Cenários com várias combinações (esquemas de cenário) têm um print representativo por variação relevante. Os números de pedido (`VZ-xxxxxx`) mudam a cada execução, então não coincidem entre arquivos.

## Evidências dos bugs

| Bug | Arquivo |
|---|---|
| BUG-001 | [Tela com 2 Mochilas](BUG-001_tela_mochila-x2.png) |
| BUG-001 | [Tela com 4 Garrafas](BUG-001_tela_garrafa-x4.png) |
| BUG-001 | [Resposta de /api/carrinho/calcular com 2 Mochilas](BUG-001_api_calcular-mochila-x2.txt) |
| BUG-002 | [/api/carrinho/calcular com 6 unidades (HTTP 200)](BUG-002_api_calcular-6-unidades.txt) |
| BUG-002 | [/api/pedidos com 6 unidades (HTTP 201)](BUG-002_api_pedidos-6-unidades.txt) |
| BUG-002 | [/api/carrinho/calcular com 5, 100 e 1000 unidades](BUG-002_api_calcular-limites.txt) |

## Cupom

| ID | Evidência | Resultado |
|---|---|---|
| CT-CUPOM-01 | [bemvindo10 aplicado](execucao/CT-CUPOM-01_08_FRETE-07_bemvindo10-aplicado.png) | Passou |
| CT-CUPOM-02 | [código em caixa mista](execucao/CT-CUPOM-02_codigo-misto.png) | Passou |
| CT-CUPOM-03 | [espaços ao redor](execucao/CT-CUPOM-03_espacos.png) | Passou |
| CT-CUPOM-04 | [cupom inexistente](execucao/CT-CUPOM-04_inexistente.png) | Passou |
| CT-CUPOM-05 | [campo vazio](execucao/CT-CUPOM-05_campo-vazio.png) | Passou |
| CT-CUPOM-06 | [cupom expirado](execucao/CT-CUPOM-06_expirado.png) | Passou |
| CT-CUPOM-07 | [expirado em minúsculas](execucao/CT-CUPOM-07_expirado-minusculo.png) | Passou |
| CT-CUPOM-08 | [campo some após aplicar](execucao/CT-CUPOM-01_08_FRETE-07_bemvindo10-aplicado.png) | Passou |
| CT-CUPOM-09 | [cupom removido](execucao/CT-CUPOM-09a_cupom-removido.png) e [reaplicado](execucao/CT-CUPOM-09b_cupom-reaplicado.png) | Passou |

## Frete

| ID | Evidência | Resultado |
|---|---|---|
| CT-FRETE-01 | [abaixo de R$ 200](execucao/CT-FRETE-01_abaixo-200.png) | Passou |
| CT-FRETE-02 | [2 Mochilas, subtotal R$ 200,00](BUG-001_tela_mochila-x2.png) e [resposta da API](BUG-001_api_calcular-mochila-x2.txt) | Falhou (BUG-001) |
| CT-FRETE-03 | [acima de R$ 200](execucao/CT-FRETE-03_acima-200.png) | Passou |
| CT-FRETE-04 | [subtotal R$ 199,80](execucao/CT-FRETE-04_199-80.png) | Passou |
| CT-FRETE-05 | [cupom com total abaixo de R$ 200](execucao/CT-FRETE-05_cupom-total-abaixo-200.png) | Passou |
| CT-FRETE-06 | [subtotal R$ 199,40 com cupom](execucao/CT-FRETE-06_199-40-com-cupom.png) | Passou |
| CT-FRETE-07 | [desconto só sobre o subtotal](execucao/CT-CUPOM-01_08_FRETE-07_bemvindo10-aplicado.png) | Passou |
| CT-FRETE-08 | [subtotal R$ 200,00 com cupom](execucao/CT-FRETE-08_200-com-cupom.png) | Falhou (BUG-001) |

## Limite de quantidade

| ID | Evidência | Resultado |
|---|---|---|
| CT-QTD-01 | [limite no carrinho](execucao/CT-QTD-01_limite-no-carrinho.png) | Passou |
| CT-QTD-02 | [limite na vitrine](execucao/CT-QTD-02_limite-na-vitrine.png) | Passou |
| CT-QTD-03 | [6 unidades](execucao/api/CT-QTD-03a_calcular-6-unidades.txt), [100](execucao/api/CT-QTD-03b_calcular-100-unidades.txt) e [1000](execucao/api/CT-QTD-03c_calcular-1000-unidades.txt) | Falhou (BUG-002) |
| CT-QTD-04 | [pedido com 6 unidades](execucao/api/CT-QTD-04_pedido-6-unidades.txt) | Falhou (BUG-002) |
| CT-QTD-05 | [5 unidades](execucao/api/CT-QTD-05_calcular-5-unidades.txt) | Passou |

## Dados do cliente e pedido

| ID | Evidência | Resultado |
|---|---|---|
| CT-PED-01 | [pedido confirmado](execucao/CT-PED-01_pedido-confirmado.png) | Passou |
| CT-PED-02 | [nome sem sobrenome](execucao/CT-PED-02_nome-sem-sobrenome.png) | Passou |
| CT-PED-03 | [e-mail sem arroba](execucao/CT-PED-03_email-sem-arroba.png) | Passou |
| CT-PED-04 | [e-mail com número no domínio](execucao/CT-PED-04_email-dominio-numero.png) | Passou |
| CT-PED-05 | [CEP sem hífen](execucao/CT-PED-05_cep-sem-hifen.png) (print representativo; os 3 formatos foram testados) | Passou |
| CT-PED-06 | [7 dígitos](execucao/CT-PED-06a_cep-7-digitos.png), [hífen na posição errada](execucao/CT-PED-06b_hifen-posicao-errada.png) e [hífen no final](execucao/CT-PED-06c_hifen-no-final.png) (prints representativos; os 7 formatos foram testados) | Passou |
| CT-PED-07 | [pagamento na entrega](execucao/CT-PED-07_pagamento-na-entrega.png) | Passou |
| CT-PED-08 | [pedido com cupom](execucao/CT-PED-08_pedido-com-cupom.png) | Passou |
| CT-PED-09 | [campos inválidos](execucao/api/CT-PED-09_campos-invalidos.txt) | Passou |
| CT-PED-10 | [pedido com CEP normalizado](execucao/api/CT-PED-10_pedido-normaliza-cep.txt) | Passou |

## API

| ID | Evidência | Resultado |
|---|---|---|
| CT-API-01 | [listar produtos](execucao/api/CT-API-01_listar-produtos.txt) | Passou |
| CT-API-02 | [produto existente](execucao/api/CT-API-02_produto-existente.txt) | Passou |
| CT-API-03 | [produto inexistente](execucao/api/CT-API-03_produto-inexistente.txt) | Passou |
| CT-API-04 | [rota inexistente](execucao/api/CT-API-04_rota-inexistente.txt) | Passou |
| CT-API-05 | [método não permitido](execucao/api/CT-API-05_metodo-nao-permitido.txt) | Passou |
| CT-API-06 | [JSON inválido](execucao/api/CT-API-06_json-invalido.txt) | Passou |
| CT-API-07 | [itens vazio](execucao/api/CT-API-07_itens-vazio.txt) | Passou |
| CT-API-08 | [item que não é objeto](execucao/api/CT-API-08_item-nao-objeto.txt) | Passou |
| CT-API-09 | [produto inexistente no item](execucao/api/CT-API-09_produto-inexistente-item.txt) | Passou |
| CT-API-10 | [item duplicado](execucao/api/CT-API-10_item-duplicado.txt) | Passou |
| CT-API-11 | [zero](execucao/api/CT-API-11a_quantidade-zero.txt), [negativa](execucao/api/CT-API-11b_quantidade-negativa.txt), [decimal](execucao/api/CT-API-11c_quantidade-decimal.txt), [texto](execucao/api/CT-API-11d_quantidade-texto.txt) e [null](execucao/api/CT-API-11e_quantidade-null.txt) | Passou |
| CT-API-12 | [cupom inexistente no cálculo](execucao/api/CT-API-12_cupom-inexistente-calculo.txt) | Passou |
| CT-API-13 | [cupom normalizado](execucao/api/CT-API-13_cupom-normalizado-calculo.txt) | Passou |
| CT-API-14 | [cupom inexistente no pedido](execucao/api/CT-API-14_cupom-inexistente-pedido.txt) | Passou |
| CT-API-15 | [cupom expirado no pedido](execucao/api/CT-API-15_cupom-expirado-pedido.txt) | Passou |
