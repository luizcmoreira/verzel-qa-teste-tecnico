import { test, expect } from '@playwright/test';

test('CT-QTD-03 - API recusa mais de 5 unidades no cálculo do carrinho (CA10)', async ({ request }) => {
  // BUG-002: a API aceita 6, 100 e 1000 unidades com HTTP 200.
  // Falha esperada: afirma o que a documentação manda (422 QUANTIDADE_MAXIMA_EXCEDIDA).
  test.fail(true, 'BUG-002: API não valida o limite de 5 unidades por produto');

  const resposta = await request.post('/api/carrinho/calcular', {
    data: { itens: [{ produtoId: 'P001', quantidade: 6 }] },
  });

  expect(resposta.status()).toBe(422);
  const corpo = await resposta.json();
  expect(corpo.erro.codigo).toBe('QUANTIDADE_MAXIMA_EXCEDIDA');
});

test('CT-API-13 - cupom em minúsculo e com espaços é normalizado no cálculo (CA02)', async ({ request }) => {
  const resposta = await request.post('/api/carrinho/calcular', {
    data: { itens: [{ produtoId: 'P001', quantidade: 1 }], cupom: '  bemvindo10  ' },
  });

  expect(resposta.status()).toBe(200);
  const corpo = await resposta.json();
  expect(corpo.cupom.codigo).toBe('BEMVINDO10');
  expect(corpo.cupom.aplicado).toBe(true);
  expect(corpo.desconto).toBe(5.99);
  expect(corpo.total).toBe(73.81);
});
