# GitHub Pages Deploy — Guia Completo para jvcss.github.io

## 1. O Problema Atual

O site está sendo servido em `https://jvcss.github.io/jvcss` ao invés de `https://jvcss.github.io`.

### Por que isso acontece?

O GitHub Pages tem **dois modos de operação** com comportamentos completamente diferentes:

| Modo | URL resultante | Repo necessário |
|------|---------------|-----------------|
| **User/Org Page** | `https://username.github.io` | `username/username` ou `username/username.github.io` |
| **Project Page** | `https://username.github.io/repo-name` | qualquer outro repo |

O repositório `jvcss/jvcss` se qualifica como **User Page** — o nome do repo (`jvcss`) bate com o username (`jvcss`). Portanto, o URL correto É `https://jvcss.github.io`, sem nenhum sufixo.

O sufixo `/jvcss` aparece quando o GitHub Pages está configurado no modo errado, ou quando o build do Flutter foi feito com `--base-href /jvcss/` ao invés de `--base-href /`.

---

## 2. As Duas Abordagens de Deploy

### Abordagem A — Branch `gh-pages` (antiga / MkDocs legado)

```
[push para main]
     │
     ▼
[GitHub Actions]
     │  flutter build web
     │  base-href = /
     ▼
[JamesIves/github-pages-deploy-action]
     │  faz push do build/web
     ▼
[branch gh-pages] ← GitHub Pages serve DAQUI
```

**Configuração no GitHub:**
> Settings → Pages → Source: **Deploy from a branch** → Branch: `gh-pages`

**Problema com esta abordagem:**
- Cria uma branch extra (`gh-pages`) que não tem relação com o código fonte
- Depende de uma GitHub Action de terceiro para fazer o push
- O token `GITHUB_TOKEN` precisa de permissão de escrita no repo
- Em repos de User Page, pode haver conflito entre o que está em `main` e o que está em `gh-pages`
- **Mais difícil de debugar** quando o deploy falha silenciosamente

---

### Abordagem B — GitHub Actions Pages nativo (moderna / recomendada)

```
[push para main]
     │
     ▼
[GitHub Actions]
     │  flutter build web
     │  base-href = /
     │
     ├─► actions/configure-pages
     ├─► actions/upload-pages-artifact  ← sobe o build/web como artefato
     └─► actions/deploy-pages           ← GitHub faz o deploy direto
                                              sem branch intermediária
```

**Configuração no GitHub:**
> Settings → Pages → Source: **GitHub Actions**

**Por que é melhor:**
- Sem branch `gh-pages` desnecessária
- O deploy é feito pela própria infraestrutura do GitHub (mais confiável)
- Permissões granulares declaradas no próprio workflow (`pages: write`, `id-token: write`)
- URL do deploy aparece como output do job (`${{ steps.deployment.outputs.page_url }}`)
- **É a abordagem oficial atual do GitHub** — toda a nova documentação usa esta

---

## 3. A Correção — Workflow Atualizado

O arquivo `.github/workflows/gh-pages.yml` deve ser:

```yaml
name: Deploy Flutter Web

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Build web
        run: flutter build web --release --base-href /

      - name: Configure Pages
        uses: actions/configure-pages@v5

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: build/web

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

**Pontos chave do workflow:**

| Campo | Valor | Motivo |
|-------|-------|--------|
| `permissions.pages: write` | declarado no topo | necessário para fazer deploy |
| `permissions.id-token: write` | declarado no topo | autenticação OIDC do GitHub |
| `environment.name: github-pages` | obrigatório | vincula ao environment de Pages |
| `--base-href /` | raiz | User Page serve na raiz, sem subfixo |
| `actions/configure-pages@v5` | configura o environment | detecta URL base automaticamente |
| `actions/upload-pages-artifact@v3` | faz upload do `build/web` | prepara o artefato para deploy |
| `actions/deploy-pages@v4` | efetua o deploy | usa a infraestrutura nativa do GitHub |

---

## 4. Passo a Passo para Corrigir

### Passo 1 — Alterar configuração no GitHub (manual, uma única vez)

1. Acesse: `https://github.com/jvcss/jvcss/settings/pages`
2. Em **"Build and deployment"**, altere **"Source"** de `Deploy from a branch` para **`GitHub Actions`**
3. Salve. O campo de branch desaparece — não é mais necessário.

### Passo 2 — O workflow já foi atualizado

O arquivo `.github/workflows/gh-pages.yml` já foi atualizado neste commit.

### Passo 3 — Push aciona o workflow

Qualquer push para `main` vai:
1. Build Flutter Web com `--base-href /`
2. Fazer upload do `build/web` como artifact
3. Fazer deploy direto via GitHub Pages nativo
4. Exibir a URL do deploy no log do Actions

---

## 5. Verificação

Após a mudança nas configurações e o próximo push:

- URL correta: `https://jvcss.github.io` (sem `/jvcss`)
- GitHub Actions log mostrará: `🚀 Deployed to https://jvcss.github.io`
- Aba "Environments" no repo mostrará `github-pages` como environment ativo

---

## 6. Por que o `--base-href /` é crítico para Flutter Web

O Flutter Web gera referências a assets (JS, CSS, fontes) usando o `base-href` como prefixo.

```html
<!-- Com --base-href / (correto para User Page) -->
<base href="/">
<!-- Carrega: https://jvcss.github.io/flutter.js ✅ -->

<!-- Com --base-href /jvcss/ (errado para User Page) -->
<base href="/jvcss/">
<!-- Carrega: https://jvcss.github.io/jvcss/flutter.js ❌ (404 em User Page) -->
```

Para **User Pages** (`username/username`): sempre usar `--base-href /`
Para **Project Pages** (`username/outro-repo`): usar `--base-href /nome-do-repo/`
