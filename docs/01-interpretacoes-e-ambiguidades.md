# Interpretações e ambiguidades

Pontos em que a documentação (v2.3.0) não define o comportamento, ou em que tela e API se comportam de forma diferente do que o texto sugere. Para cada um, registrei a minha interpretação e segui com os testes. Nenhum deles foi tratado como bug, exceto onde indicado.

Os comportamentos listados na seção "Sobre este ambiente" da documentação (carrinho só na aba, pedidos não armazenados, sem e-mail nem cobrança, produtos e cupons fixos, sem controle de estoque, API sem estado) também não foram tratados como bug.

| ID | Tema | O que a documentação diz | O que observei | Interpretação adotada |
|---|---|---|---|---|
| AMB-01 | Cupom "na primeira compra" | Nenhum critério de primeira compra nos CAs. | O banner da loja anuncia o cupom para a primeira compra, mas o sistema aceita BEMVINDO10 em qualquer pedido. | Não há como identificar cliente (sem login nem histórico). Tratei como texto de marketing, sem regra de negócio, e não abri bug. |
| AMB-02 | Cupom vazio ou só com espaços | Não define. | A tela mostra "Informe um cupom." e não chama o cálculo. | Comportamento razoável: tratei como validação de campo obrigatório (CT-CUPOM-05). |
| AMB-03 | Acento no código do cupom | CA02 normaliza só maiúsculas/minúsculas e espaços nas pontas. | `VERÃO2026` retorna "Cupom inválido.". | Segui o CA02 ao pé da letra: apenas caixa e espaços nas pontas são normalizados. Código com acento é código diferente. |
| AMB-04 | Segundo cupom (CA05) | "Um cupom por vez." | A tela esconde o campo de cupom depois de aplicado e mostra só "Remover cupom". | A regra é garantida pela interface, então não dá para tentar um segundo cupom pela tela (CT-CUPOM-08). A API de cálculo recebe um único cupom por contrato. |
| AMB-05 | Mensagem de validação do checkout | Não define quando a mensagem some. | Depois de um erro (nome, e-mail ou CEP), a mensagem continua visível até o próximo envio, mesmo com o campo já corrigido. | Observação de usabilidade, sem critério na doc. Não abri bug. |
| AMB-06 | Botão "Aplicar cupom" durante a chamada | Não define. | O botão fica desabilitado e acinzentado enquanto a API responde. | Comportamento esperado de proteção contra clique duplo. Sem impacto. |
| AMB-07 | Quantidade como texto | Erro `QUANTIDADE_INVALIDA` para quantidade que não seja inteiro >= 1. | `"2"` (string) é recusada, não convertida para 2. | A API valida o tipo estritamente. Tratei como correto (CT-API-11). |
| AMB-08 | `PRODUTO_NAO_ENCONTRADO` com dois status | Tabela de erros lista o código com 404 (consulta de produto) e 422 (item de pedido/cálculo). | O mesmo código volta com status diferente conforme o endpoint. | Interpretei como intencional: 404 quando o produto é o recurso consultado, 422 quando é uma referência dentro do body. |
| AMB-09 | "Pedido registrado" | A mensagem diz que o pedido foi registrado. | O ambiente não armazena pedidos. | Esperado pela nota "Sobre este ambiente". Não é bug. |
| AMB-10 | Formato do CEP | Não detalha as regras. | O hífen é opcional, mas, se presente, precisa estar depois do 5º dígito. `12-345678`, `123-45678`, `1234567-8`, `12345678-`, `-12345678` e `12345-678-` são recusados (CT-PED-06). | Documentei as regras observadas como o comportamento de referência. |
| AMB-11 | Validação do CEP | Não define se o CEP é consultado. | `12345678` é aceito: só o formato é validado. Não consegui verificar se há consulta externa, só que um CEP bem formado e inexistente passa. | Afirmei apenas o que observei: validação de formato. |
| AMB-12 | Normalização na API | CA02 fala de cupom; nada sobre CEP. | A API devolve o CEP só com dígitos (`01310100`) e o código do cupom em maiúsculas e sem espaços. | Tratei como comportamento correto e testei (CT-PED-10, CT-API-13). |
| AMB-13 | Carrinho após confirmar pedido | Não define. | Após confirmar, o carrinho é zerado e não dá para voltar ao checkout com a mesma compra. | Esperado, dado que pedidos não são armazenados. Não é bug. |
| AMB-14 | Severidade dos bugs | A doc não define níveis. | Sem controle de estoque no ambiente, o impacto financeiro é indireto. | Classifiquei os dois bugs como Alta pelo efeito no cliente real (cobrança de frete indevido e pedido fora da regra), deixando o risco de estoque como observação. |
