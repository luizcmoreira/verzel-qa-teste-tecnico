# Execução dos testes

**Data:** 06/10/2026
**Ambiente:** https://verzel-store.qa-test-verzel-store.workers.dev/
**Tipo:** testes manuais e exploratórios pela tela (carrinho e checkout) e pela API (requisições com curl)
**Executor:** Luiz

## Resumo

| Arquivo de cenários | Total | Passou | Falhou |
|---|---|---|---|
| cupom.feature | 9 | 9 | 0 |
| frete.feature | 8 | 6 | 2 |
| limite-quantidade.feature | 5 | 3 | 2 |
| pedido-cliente.feature | 10 | 10 | 0 |
| api.feature | 15 | 15 | 0 |
| **Total** | **47** | **43** | **4** |

As 4 falhas se resumem a 2 bugs: [BUG-001](04-bugs/BUG-001.md) (frete grátis em R$ 200,00) e [BUG-002](04-bugs/BUG-002.md) (API sem limite de 5 unidades).

## Cupom (docs/02-cenarios/cupom.feature)

| ID | CA | Esperado | Obtido | Status |
|---|---|---|---|---|
| CT-CUPOM-01 | CA01 | Desconto R$ 5,99 e total R$ 73,81, com a confirmação "Cupom BEMVINDO10 aplicado." | Conforme | Passou |
| CT-CUPOM-02 | CA02 | `bemvindo10`, `BemVindo10` e `bEMvINDO10` aplicam 10% | Conforme nos três códigos | Passou |
| CT-CUPOM-03 | CA02 | Espaços no início e no fim são ignorados | Conforme | Passou |
| CT-CUPOM-04 | CA03 | "Cupom inválido.", desconto R$ 0,00, total R$ 79,80 | Conforme | Passou |
| CT-CUPOM-05 | CA03 | Doc não define; esperado sem desconto | Mensagem "Informe um cupom.", sem desconto (ver 01-interpretacoes) | Passou |
| CT-CUPOM-06 | CA04 | "Cupom expirado.", desconto R$ 0,00, total R$ 79,80 | Conforme | Passou |
| CT-CUPOM-07 | CA02, CA04 | `verao2026` retorna "Cupom expirado." | Conforme | Passou |
| CT-CUPOM-08 | CA05 | Com cupom aplicado, não há campo para outro cupom | Campo some e aparece "Remover cupom" | Passou |
| CT-CUPOM-09 | CA05 | Remover zera o desconto; reaplicar funciona | Conforme | Passou |

## Frete (docs/02-cenarios/frete.feature)

| ID | CA | Esperado | Obtido | Status |
|---|---|---|---|---|
| CT-FRETE-01 | CA07 | Frete R$ 19,90, total R$ 79,80, "Faltam R$ 140,10 para o frete grátis." | Conforme | Passou |
| CT-FRETE-02 | CA06 | Subtotal R$ 200,00: frete R$ 0,00 e total R$ 200,00 | Frete R$ 19,90 e total R$ 219,90, com "Faltam R$ 0,00 para o frete grátis." | **Falhou** ([BUG-001](04-bugs/BUG-001.md)) |
| CT-FRETE-03 | CA06 | Subtotal R$ 219,80: frete "Grátis", total R$ 219,80 | Conforme | Passou |
| CT-FRETE-04 | CA07 | Subtotal R$ 199,80: frete R$ 19,90, total R$ 219,70, "Faltam R$ 0,20..." | Conforme | Passou |
| CT-FRETE-05 | CA08 | Com cupom, desconto R$ 21,98, total R$ 197,82 e frete continua "Grátis" | Conforme | Passou |
| CT-FRETE-06 | CA08 | Subtotal R$ 199,40 com cupom: desconto R$ 19,94, frete R$ 19,90, total R$ 199,36, "Faltam R$ 0,60..." | Conforme | Passou |
| CT-FRETE-07 | CA09 | Desconto R$ 5,99 (só sobre o subtotal), frete R$ 19,90, total R$ 73,81 | Conforme | Passou |
| CT-FRETE-08 | CA06, CA08 | Subtotal R$ 200,00 com cupom: desconto R$ 20,00, frete R$ 0,00, total R$ 180,00 | Desconto R$ 20,00, frete R$ 19,90, total R$ 199,90 | **Falhou** ([BUG-001](04-bugs/BUG-001.md)) |

## Limite de quantidade (docs/02-cenarios/limite-quantidade.feature)

| ID | CA | Esperado | Obtido | Status |
|---|---|---|---|---|
| CT-QTD-01 | CA10 | Chega a 5 unidades, aparece o aviso de limite e o "+" fica desabilitado | Conforme | Passou |
| CT-QTD-02 | CA10 | Na vitrine, produto com 5 unidades tem o botão desabilitado e "Limite de 5 unidades atingido." | Conforme | Passou |
| CT-QTD-03 | CA10 | Com 6, 100 e 1000 unidades: HTTP 422 e `QUANTIDADE_MAXIMA_EXCEDIDA` | HTTP 200 e cálculo normal nos três valores | **Falhou** ([BUG-002](04-bugs/BUG-002.md)) |
| CT-QTD-04 | CA10 | `POST /api/pedidos` com 6 unidades: HTTP 422 | HTTP 201 e pedido VZ-714610 criado | **Falhou** ([BUG-002](04-bugs/BUG-002.md)) |
| CT-QTD-05 | CA10 | 5 unidades: HTTP 200, total 299,50 | Conforme | Passou |

## Dados do cliente e pedido (docs/02-cenarios/pedido-cliente.feature)

| ID | CA | Esperado | Obtido | Status |
|---|---|---|---|---|
| CT-PED-01 | regra existente | Pedido confirmado, número VZ-000000 e mensagem de agradecimento | Conforme (ex.: VZ-415365) | Passou |
| CT-PED-02 | regra existente | Nome sem sobrenome: "Informe nome e sobrenome." | Conforme | Passou |
| CT-PED-03 | regra existente | E-mail sem @: "Informe um e-mail válido." | Conforme | Passou |
| CT-PED-04 | regra existente | `joao.joanio@exemplo2.com` é aceito | Conforme | Passou |
| CT-PED-05 | regra existente | CEP `01310-100`, `01310100` e `12345678` são aceitos | Conforme nos três | Passou |
| CT-PED-06 | regra existente | CEP com 7 dígitos ou hífen fora do lugar: "Informe um CEP com 8 dígitos." | Conforme nos sete formatos | Passou |
| CT-PED-07 | regra existente | "O pagamento é feito na entrega." e só nome, e-mail e CEP | Conforme | Passou |
| CT-PED-08 | CA01 | Pedido com cupom: desconto R$ 4,99 e total R$ 64,81 | Conforme | Passou |
| CT-PED-09 | regra existente | HTTP 422 `DADOS_INVALIDOS` listando nome, e-mail e CEP | Conforme | Passou |
| CT-PED-10 | regra existente | HTTP 201, número VZ-000000 e CEP `01310100` | Conforme | Passou |

## API (docs/02-cenarios/api.feature)

| ID | CA | Esperado | Obtido | Status |
|---|---|---|---|---|
| CT-API-01 | - | GET /api/produtos: 200 e 8 produtos | Conforme | Passou |
| CT-API-02 | - | GET /api/produtos/P001: 200 | Conforme | Passou |
| CT-API-03 | - | GET /api/produtos/P999: 404 `PRODUTO_NAO_ENCONTRADO` | Conforme | Passou |
| CT-API-04 | - | Rota inexistente: 404 `ROTA_NAO_ENCONTRADA` | Conforme | Passou |
| CT-API-05 | - | GET em /api/carrinho/calcular: 405 `METODO_NAO_PERMITIDO` | Conforme | Passou |
| CT-API-06 | - | Corpo inválido: 400 `JSON_INVALIDO` | Conforme | Passou |
| CT-API-07 | - | `itens` vazio: 422 `ITENS_OBRIGATORIOS` | Conforme | Passou |
| CT-API-08 | - | Item não objeto: 422 `ITEM_INVALIDO` | Conforme | Passou |
| CT-API-09 | - | Produto inexistente no item: 422 `PRODUTO_NAO_ENCONTRADO` | Conforme | Passou |
| CT-API-10 | - | Produto duplicado: 422 `ITEM_DUPLICADO` | Conforme | Passou |
| CT-API-11 | - | Quantidade 0, -1, 1.5, "2" e null: 422 `QUANTIDADE_INVALIDA` | Conforme nos cinco valores | Passou |
| CT-API-12 | CA03 | Cupom inexistente no cálculo: 200, `aplicado: false`, "Cupom inválido." | Conforme | Passou |
| CT-API-13 | CA02 | `  bemvindo10  ` normalizado para `BEMVINDO10`, desconto 5.99, total 73.81 | Conforme | Passou |
| CT-API-14 | CA03 | Cupom inexistente no pedido: 422 `CUPOM_INVALIDO` | Conforme | Passou |
| CT-API-15 | CA04 | Cupom expirado no pedido: 422 `CUPOM_EXPIRADO` | Conforme | Passou |

## Observações e ambiguidades

Comportamentos não definidos pela doc e interpretações adotadas estão em [01-interpretacoes-e-ambiguidades.md](01-interpretacoes-e-ambiguidades.md).
