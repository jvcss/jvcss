# GitHub Pages Deploy — Guia Completo para jvcss.github.io/jvcss/

## 1. Como o GitHub Pages Funciona — Dois Tipos de Repo

O GitHub Pages tem dois tipos de publicação com comportamentos fundamentalmente diferentes:

### User/Org Pages — exige repo com nome especial

| Repo necessário | URL resultante |
|-----------------|----------------|
| `jvcss/jvcss.github.io` | `https://jvcss.github.io/` |

Para ter o site na raiz do domínio `https://jvcss.github.io`, é **obrigatório** criar um repositório com o nome exato `jvcss.github.io`. Este repo é exclusivo para essa finalidade.

### Project Pages — qualquer outro repo

| Repo | URL resultante |
|------|----------------|
| `jvcss/jvcss` | `https://jvcss.github.io/jvcss/` |
| `jvcss/portfolio` | `https://jvcss.github.io/portfolio/` |
| `jvcss/blog` | `https://jvcss.github.io/blog/` |

Todo repo que não seja `username.github.io` serve como **project page** com o nome do repo como subpath.

---

## 2. O Repo `jvcss/jvcss` — Profile README, não User Page

O repo `jvcss/jvcss` é um **repo especial do GitHub** com uma funcionalidade distinta: ele exibe o `README.md` na página de perfil do usuário (`github.com/jvcss`). Esse é o chamado **Profile README**.

Ele NÃO é o mesmo que o repo de User Pages. São features completamente separadas:

| Feature | Repo | Efeito |
|---------|------|--------|
| Profile README | `jvcss/jvcss` | Exibe README em `github.com/jvcss` |
| User Pages | `jvcss/jvcss.github.io` | Publica site em `https://jvcss.github.io/` |

Ambos podem existir ao mesmo tempo, com funções diferentes.

---

## 3. Situação Atual — Project Page em `/jvcss/`

Por não existir o repo `jvcss.github.io`, o site do portfolio fica em:

**`https://jvcss.github.io/jvcss/`**

Esta é a URL correta, definitiva e obrigatória para o repo `jvcss/jvcss` enquanto não houver o repo separado.

---

## 4. Por que o `--base-href /jvcss/` é Crítico

O Flutter Web gera um `index.html` com uma tag `<base href="...">` que define o prefixo de todos os assets (JS, CSS, fontes, imagens). Se esse valor não bater com o subpath real onde o site está hospedado, todos os assets retornam 404.

```html
<!-- Com --base-href /jvcss/ (correto) -->
<base href="/jvcss/">
<!-- Carrega: https://jvcss.github.io/jvcss/flutter.js ✅ -->

<!-- Com --base-href / (incorreto para project page) -->
<base href="/">
<!-- Busca: https://jvcss.github.io/flutter.js → 404 ❌ -->
```

**Regra geral:**

| Tipo de página | Valor correto de `--base-href` |
|----------------|-------------------------------|
| User Page (`username.github.io`) | `--base-href /` |
| Project Page (`username/repo`) | `--base-href /nome-do-repo/` |

Para este projeto: `--base-href /jvcss/`

---

## 5. Workflow Atual — GitHub Actions Pages Nativo

O arquivo `.github/workflows/gh-pages.yml` usa a abordagem oficial do GitHub:

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
        run: flutter build web --release --base-href /jvcss/

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

### Por que GitHub Actions Pages nativo (não branch `gh-pages`)

- Sem branch intermediária (`gh-pages`) com conteúdo gerado
- Deploy feito pela infraestrutura nativa do GitHub (mais confiável)
- Permissões declaradas explicitamente no workflow
- URL do deploy exibida no log do Actions

### Configuração necessária no GitHub (feita uma única vez)

> Settings → Pages → Build and deployment → Source: **GitHub Actions**

---

## 6. Verificação do Deploy

Após cada push para `main`:

1. Acompanhar em: `https://github.com/jvcss/jvcss/actions`
2. Site disponível em: `https://jvcss.github.io/jvcss/`
3. Sem erros 404 no console do browser
4. Assets carregados: `flutter_bootstrap.js`, `main.dart.js`, `manifest.json`
