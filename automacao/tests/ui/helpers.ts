import { expect, Page } from '@playwright/test';

export async function adicionar(page: Page, produto: string, vezes = 1) {
  const botao = page
    .getByRole('article', { name: produto })
    .getByRole('button', { name: 'Adicionar ao carrinho' });
  for (let i = 0; i < vezes; i++) await botao.click();
}

export async function abrirCarrinho(page: Page) {
  await page.getByRole('link', { name: /^Carrinho/ }).click();
  await expect(page.getByRole('heading', { name: 'Carrinho', level: 1 })).toBeVisible();
}

export async function aplicarCupom(page: Page, codigo: string) {
  await page.getByRole('textbox', { name: 'Cupom de desconto' }).fill(codigo);
  await page.getByRole('button', { name: 'Aplicar cupom' }).click();
}

/** Valor do resumo do pedido (Subtotal, Desconto, Frete ou Total). */
export function resumo(page: Page, rotulo: 'Subtotal' | 'Desconto' | 'Frete' | 'Total') {
  return page
    .locator('dt', { hasText: new RegExp(`^${rotulo}`) })
    .locator('xpath=following-sibling::dd[1]');
}
