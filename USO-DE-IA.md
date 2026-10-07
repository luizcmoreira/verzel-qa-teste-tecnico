# Uso de IA neste teste

Usei o **Claude (Anthropic)**, em um chat, como copiloto de pair programming. O trabalho foi feito em passos curtos, com discussão a cada decisão. Eu não pedia "faça isso" e recebia pronto. Quando algo vinha incompleto ou errado, eu corrigia.

## O que partiu de mim

- Exploração da loja e da API e execução manual de todos os cenários, tela e chamadas HTTP.
- Prints de tela cheia e a decisão de como organizar as evidências.
- Identificação dos 2 bugs, reprodução e a decisão da severidade de cada um (Alta), com a justificativa pelo impacto no cliente.
- Escolha do que é bug e do que é comportamento esperado do ambiente, e o registro das ambiguidades.
- Correções ao material da IA: tags `@CA` trocadas, valores esperados que não seguiam a documentação, cenário escrito com o comportamento defeituoso observado em vez do exigido, severidade baseada em estoque que o ambiente não tem, entre outros.

## O que construímos juntos

- Os cenários em Gherkin: eu escrevia e testava, a IA revisava a rastreabilidade com os critérios de aceitação e propunha ajustes.
- Os relatórios de bug (título, passos, esperado e obtido) e o documento de execução.
- A organização do repositório e as convenções de IDs e tags.

## Onde a IA escreveu mais

- Os scripts de apoio (`scripts/evidencias-api.sh` e `scripts/verificar-repo.sh`).
- A base dos testes Playwright e do README, que eu rodei, ajustei e conferi contra a loja real.

## Como conferi o resultado

Todos os resultados foram conferidos por mim contra o comportamento real da loja. As respostas da API estão gravadas como evidência em `docs/05-evidencias/`, e o script `scripts/verificar-repo.sh` confere a consistência entre cenários, execução e evidências.
