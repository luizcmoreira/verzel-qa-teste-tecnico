import { test, expect } from '@playwright/test';
import { abrirCarrinho, adicionar, aplicarCupom, resumo } from './helpers';

test.describe('Cupom de desconto', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await adicionar(page, 'Camiseta Essencial');
    await abrirCarrinho(page);
  });

  test('CT-CUPOM-01 - BEMVINDO10 aplica 10% sobre os produtos (CA01)', async ({ page }) => {
    await aplicarCupom(page, 'BEMVINDO10');

    await expect(page.getByText('Cupom BEMVINDO10 aplicado.')).toBeVisible();
    await expect(resumo(page, 'Desconto')).toContainText('R$ 5,99');
    await expect(resumo(page, 'Frete')).toHaveText('R$ 19,90');
    await expect(resumo(page, 'Total')).toHaveText('R$ 73,81');
  });

  test('CT-CUPOM-04 - cupom inexistente é recusado e não altera o total (CA03)', async ({ page }) => {
    await aplicarCupom(page, 'NAOEXISTE');

    await expect(page.getByText('Cupom inválido.')).toBeVisible();
    await expect(resumo(page, 'Desconto')).toHaveText('R$ 0,00');
    await expect(resumo(page, 'Total')).toHaveText('R$ 79,80');
  });
});
