import { test, expect } from '@playwright/test';
import { abrirCarrinho, adicionar, resumo } from './helpers';

test('CT-FRETE-02 - subtotal de R$ 200,00 tem frete grátis (CA06)', async ({ page }) => {
  // BUG-001: com subtotal exatamente R$ 200,00 o frete de R$ 19,90 ainda é cobrado.
  // Este teste afirma o que a documentação manda e é marcado como falha esperada.
  // Quando o bug for corrigido, ele passa a falhar e a marcação deve ser removida.
  test.fail(true, 'BUG-001: frete grátis não é aplicado com subtotal igual a R$ 200,00');

  await page.goto('/');
  await adicionar(page, 'Mochila Urbana 20L', 2);
  await abrirCarrinho(page);

  await expect(resumo(page, 'Subtotal')).toHaveText('R$ 200,00');
  await expect(resumo(page, 'Total')).toHaveText('R$ 200,00');
});

test('CT-QTD-01 - tela permite chegar a 5 unidades e bloqueia o aumento (CA10)', async ({ page }) => {
  await page.goto('/');
  await adicionar(page, 'Camiseta Essencial');
  await abrirCarrinho(page);

  const aumentar = page.getByRole('button', { name: 'Aumentar quantidade de Camiseta Essencial' });
  for (let i = 0; i < 4; i++) await aumentar.click();

  await expect(page.getByRole('status', { name: 'Quantidade de Camiseta Essencial' })).toHaveText('5');
  await expect(aumentar).toBeDisabled();
  await expect(page.getByText('Limite de 5 unidades por produto.')).toBeVisible();
});
