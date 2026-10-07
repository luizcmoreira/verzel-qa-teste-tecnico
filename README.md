# Teste técnico QA Júnior - Verzel Store (VZS-142 v2.3.0)

Teste funcional da funcionalidade **cupom de desconto + frete grátis** da Verzel Store:
- Loja: https://verzel-store.qa-test-verzel-store.workers.dev/
- Documentação: https://verzel-store.qa-test-verzel-store.workers.dev/documentacao
- API: https://verzel-store.qa-test-verzel-store.workers.dev/api

## Resultado em resumo

- **47 cenários** derivados da documentação, escritos em Gherkin (português).
- **43 passaram e 4 falharam**, o que resulta em **2 bugs**, ambos de severidade Alta:
  - [BUG-001](docs/04-bugs/BUG-001.md): frete grátis não é aplicado quando o subtotal é exatamente R$ 200,00.
  - [BUG-002](docs/04-bugs/BUG-002.md): a API aceita mais de 5 unidades do mesmo produto (`/api/carrinho/calcular` e `/api/pedidos`).
- **6 cenários automatizados** com Playwright.

## Onde está cada entregável

| Entregável | Onde |
|---|---|
| Cenários de teste (Gherkin) | [docs/02-cenarios/](docs/02-cenarios/): `cupom`, `frete`, `limite-quantidade`, `pedido-cliente` e `api` (`.feature`) |
| Execução manual/exploratória, com resultado de cada cenário | [docs/03-execucao.md](docs/03-execucao.md) |
| Relatório de bugs | [docs/04-bugs/](docs/04-bugs/) |
| Evidências (telas e respostas da API) | [docs/05-evidencias/](docs/05-evidencias/README.md): tabela de cada cenário com o arquivo correspondente |
| Automação com Playwright | [automacao/](automacao/) |
| Interpretações de pontos ambíguos | [docs/01-interpretacoes-e-ambiguidades.md](docs/01-interpretacoes-e-ambiguidades.md) |

## Estrutura do repositório

cd automacao
npm pkg set scripts.test="playwright test" scripts.report="playwright show-report"
cd ..

cat > README.md <<'EOF'
# Teste técnico QA Júnior - Verzel Store (VZS-142 v2.3.0)

Teste funcional da funcionalidade **cupom de desconto + frete grátis** da Verzel Store:
- Loja: https://verzel-store.qa-test-verzel-store.workers.dev/
- Documentação: https://verzel-store.qa-test-verzel-store.workers.dev/documentacao
- API: https://verzel-store.qa-test-verzel-store.workers.dev/api

## Resultado em resumo

- **47 cenários** derivados da documentação, escritos em Gherkin (português).
- **43 passaram e 4 falharam**, o que resulta em **2 bugs**, ambos de severidade Alta:
  - [BUG-001](docs/04-bugs/BUG-001.md): frete grátis não é aplicado quando o subtotal é exatamente R$ 200,00.
  - [BUG-002](docs/04-bugs/BUG-002.md): a API aceita mais de 5 unidades do mesmo produto (`/api/carrinho/calcular` e `/api/pedidos`).
- **6 cenários automatizados** com Playwright.

## Onde está cada entregável

| Entregável | Onde |
|---|---|
| Cenários de teste (Gherkin) | [docs/02-cenarios/](docs/02-cenarios/): `cupom`, `frete`, `limite-quantidade`, `pedido-cliente` e `api` (`.feature`) |
| Execução manual/exploratória, com resultado de cada cenário | [docs/03-execucao.md](docs/03-execucao.md) |
| Relatório de bugs | [docs/04-bugs/](docs/04-bugs/) |
| Evidências (telas e respostas da API) | [docs/05-evidencias/](docs/05-evidencias/README.md): tabela de cada cenário com o arquivo correspondente |
| Automação com Playwright | [automacao/](automacao/) |
| Interpretações de pontos ambíguos | [docs/01-interpretacoes-e-ambiguidades.md](docs/01-interpretacoes-e-ambiguidades.md) |

## Estrutura do repositório

.
├── README.md
├── automacao/ testes Playwright (TypeScript)
│ ├── playwright.config.ts
│ └── tests/
│ ├── ui/ testes de tela (carrinho, cupom, frete, limite)
│ └── api/ testes de API
├── docs/
│ ├── 01-interpretacoes-e-ambiguidades.md
│ ├── 02-cenarios/ cenários em Gherkin
│ ├── 03-execucao.md resultado de cada cenário
│ ├── 04-bugs/ BUG-001 e BUG-002
│ └── 05-evidencias/ prints e respostas da API
└── scripts/
├── evidencias-api.sh executa os cenários de API e grava as respostas
└── verificar-repo.sh confere a consistência entre cenários, execução e evidências


## Como rodar a automação

Requisitos: Node.js 18 ou superior e npm.

```bash
cd automacao
npm install
npx playwright install chromium        # no Linux/WSL: npx playwright install --with-deps chromium
npm test                               # roda os 6 testes
npm run report                         # abre o relatório HTML
```

Os testes usam a URL pública da loja (configurada em `automacao/playwright.config.ts`) e não precisam de nenhuma configuração extra.

### Cenários automatizados

| ID | Tipo | O que verifica | Resultado esperado na suíte |
|---|---|---|---|
| CT-CUPOM-01 | UI | BEMVINDO10 aplica 10% e o total fecha em R$ 73,81 | passa |
| CT-CUPOM-04 | UI | Cupom inexistente é recusado e não altera o total | passa |
| CT-QTD-01 | UI | Tela permite chegar a 5 unidades e bloqueia o aumento | passa |
| CT-API-13 | API | Cupom em minúsculo e com espaços é normalizado | passa |
| CT-FRETE-02 | UI | Subtotal de R$ 200,00 tem frete grátis | **falha esperada** (BUG-001) |
| CT-QTD-03 | API | API recusa mais de 5 unidades | **falha esperada** (BUG-002) |

Os dois cenários que reproduzem bugs afirmam o que a **documentação** manda e estão marcados com `test.fail()`. Enquanto o bug existir, o Playwright os reporta como aprovados (falha esperada). Quando o bug for corrigido, eles passam a falhar, avisando que a marcação deve ser removida.

## Scripts de apoio

```bash
./scripts/evidencias-api.sh    # roda os cenários de API e grava status, headers e body em docs/05-evidencias/execucao/api/
./scripts/verificar-repo.sh    # confere IDs de cenários, links dos .md e arquivos vazios
```

No `evidencias-api.sh`, as linhas `DIFF` esperadas são as do BUG-002 (CT-QTD-03 e CT-QTD-04).

## Convenções

- **IDs:** `CT-<ÁREA>-<NN>` (CUPOM, FRETE, QTD, PED, API), usados nos `.feature`, na execução, nas evidências e na automação.
- **Tags Gherkin:** `@CAxx` liga o cenário ao critério de aceitação; `@regra-existente` marca regras que a documentação já descreve fora dos CAs; `@api` marca cenários de API.
- **Fora do escopo:** testes de carga, estresse e segurança, conforme o enunciado.
- **Simplificações do ambiente** descritas em "Sobre este ambiente" na documentação (pedidos não armazenados, sem controle de estoque, etc.) não foram tratadas como bug.

## Uso de IA

Usei o Claude (Anthropic) como apoio durante todo o teste. Fui eu quem explorou a loja e a API, executou os cenários manualmente, tirou os prints e identificou os bugs. A IA me ajudou a revisar os cenários e a estrutura do repositório, a escrever os scripts de apoio e os testes Playwright, e a revisar a redação dos documentos. Os resultados foram conferidos por mim contra o comportamento real da loja.
