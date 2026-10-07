#!/usr/bin/env bash
# Executa os cenários CT-API-01..15 e grava status + headers + body em docs/05-evidencias/execucao/api/
BASE="https://verzel-store.qa-test-verzel-store.workers.dev"
OUT="docs/05-evidencias/execucao/api"
mkdir -p "$OUT"

# run <arquivo> <método> <caminho> <body|-> <status esperado> <regex esperado no body>
run() {
  local file="$1" method="$2" path="$3" body="$4" exp_status="$5" exp_re="$6"
  if [ "$body" = "-" ]; then
    curl -s -i -X "$method" "$BASE$path" > "$OUT/$file.txt"
  else
    curl -s -i -X "$method" "$BASE$path" -H "Content-Type: application/json" -d "$body" > "$OUT/$file.txt"
  fi
  local got
  got=$(head -n 1 "$OUT/$file.txt" | grep -o '[0-9]\{3\}' | head -n 1)
  if [ "$got" = "$exp_status" ] && grep -Eq "$exp_re" "$OUT/$file.txt"; then
    echo "OK    $file (HTTP $got)"
  else
    echo "DIFF  $file (esperado $exp_status / $exp_re, obtido HTTP $got)"
  fi
}

CLI='"cliente":{"nome":"Maria Silva","email":"maria@exemplo.com","cep":"01310-100"}'

run CT-API-01_listar-produtos          GET    /api/produtos            - 200 'P001'
run CT-API-02_produto-existente        GET    /api/produtos/P001       - 200 'P001'
run CT-API-03_produto-inexistente      GET    /api/produtos/P999       - 404 'PRODUTO_NAO_ENCONTRADO'
run CT-API-04_rota-inexistente         GET    /api/rota-inexistente    - 404 'ROTA_NAO_ENCONTRADA'
run CT-API-06_json-invalido            POST   /api/carrinho/calcular   '{"itens": [' 400 'JSON_INVALIDO'
run CT-API-07_itens-vazio              POST   /api/carrinho/calcular   '{"itens":[]}' 422 'ITENS_OBRIGATORIOS'
run CT-API-08_item-nao-objeto          POST   /api/carrinho/calcular   '{"itens":["P001"]}' 422 'ITEM_INVALIDO'
run CT-API-09_produto-inexistente-item POST   /api/carrinho/calcular   '{"itens":[{"produtoId":"P999","quantidade":1}]}' 422 'PRODUTO_NAO_ENCONTRADO'
run CT-API-10_item-duplicado           POST   /api/carrinho/calcular   '{"itens":[{"produtoId":"P001","quantidade":1},{"produtoId":"P001","quantidade":1}]}' 422 'ITEM_DUPLICADO'

run CT-API-11a_quantidade-zero         POST   /api/carrinho/calcular   '{"itens":[{"produtoId":"P001","quantidade":0}]}'   422 'QUANTIDADE_INVALIDA'
run CT-API-11b_quantidade-negativa     POST   /api/carrinho/calcular   '{"itens":[{"produtoId":"P001","quantidade":-1}]}'  422 'QUANTIDADE_INVALIDA'
run CT-API-11c_quantidade-decimal      POST   /api/carrinho/calcular   '{"itens":[{"produtoId":"P001","quantidade":1.5}]}' 422 'QUANTIDADE_INVALIDA'
run CT-API-11d_quantidade-texto        POST   /api/carrinho/calcular   '{"itens":[{"produtoId":"P001","quantidade":"2"}]}' 422 'QUANTIDADE_INVALIDA'

run CT-API-12_cupom-inexistente-calculo  POST /api/carrinho/calcular '{"itens":[{"produtoId":"P001","quantidade":1}],"cupom":"NAOEXISTE"}' 200 '"aplicado" ?: ?false'
run CT-API-13_cupom-normalizado-calculo  POST /api/carrinho/calcular '{"itens":[{"produtoId":"P001","quantidade":1}],"cupom":" bemvindo10 "}' 200 '"aplicado" ?: ?true'
run CT-API-14_cupom-inexistente-pedido   POST /api/pedidos "{$CLI,\"itens\":[{\"produtoId\":\"P001\",\"quantidade\":1}],\"cupom\":\"NAOEXISTE\"}" 422 'CUPOM_INVALIDO'
run CT-API-15_cupom-expirado-pedido      POST /api/pedidos "{$CLI,\"itens\":[{\"produtoId\":\"P001\",\"quantidade\":1}],\"cupom\":\"VERAO2026\"}" 422 'CUPOM_EXPIRADO'

# --- Limite de quantidade (CA10) ---
# CT-QTD-03 e CT-QTD-04: a doc manda 422 QUANTIDADE_MAXIMA_EXCEDIDA. DIFF aqui = BUG-002.
run CT-QTD-03a_calcular-6-unidades     POST /api/carrinho/calcular '{"itens":[{"produtoId":"P001","quantidade":6}]}'    422 'QUANTIDADE_MAXIMA_EXCEDIDA'
run CT-QTD-03b_calcular-100-unidades   POST /api/carrinho/calcular '{"itens":[{"produtoId":"P001","quantidade":100}]}'  422 'QUANTIDADE_MAXIMA_EXCEDIDA'
run CT-QTD-03c_calcular-1000-unidades  POST /api/carrinho/calcular '{"itens":[{"produtoId":"P001","quantidade":1000}]}' 422 'QUANTIDADE_MAXIMA_EXCEDIDA'
run CT-QTD-04_pedido-6-unidades        POST /api/pedidos "{$CLI,\"itens\":[{\"produtoId\":\"P001\",\"quantidade\":6}]}" 422 'QUANTIDADE_MAXIMA_EXCEDIDA'
run CT-QTD-05_calcular-5-unidades      POST /api/carrinho/calcular '{"itens":[{"produtoId":"P001","quantidade":5}]}'    200 '"quantidade" ?: ?5'

# --- Pedido: cenários de API ---
run CT-PED-09_campos-invalidos         POST /api/pedidos '{"cliente":{"nome":"Maria","email":"maria.exemplo.com","cep":"123"},"itens":[{"produtoId":"P001","quantidade":1}]}' 422 'DADOS_INVALIDOS'
run CT-PED-10_pedido-normaliza-cep     POST /api/pedidos "{$CLI,\"itens\":[{\"produtoId\":\"P001\",\"quantidade\":1}]}" 201 '"01310100"'

# --- Correções de alinhamento com api.feature ---
run CT-API-05_metodo-nao-permitido     GET  /api/carrinho/calcular - 405 'METODO_NAO_PERMITIDO'
run CT-API-11e_quantidade-null         POST /api/carrinho/calcular '{"itens":[{"produtoId":"P001","quantidade":null}]}' 422 'QUANTIDADE_INVALIDA'
