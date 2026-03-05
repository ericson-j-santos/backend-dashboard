# backend-dashboard

Serviço FastAPI simples para dashboard e login mockado.

## Pré-requisitos

- Python 3.12+
- (Opcional) hook de deploy do Render

## Setup

1. `python3 -m venv venv && source venv/bin/activate`
2. `pip install -r requirements.txt`
3. `cp .env.example .env` e preencha `RENDER_DEPLOY_HOOK` (URL do deploy hook do Render). `DOCS_URL` já vem definido.

## Executar local

- `./run.sh` (cria/ativa venv, instala deps se faltarem e escolhe porta livre a partir de 8000)

## Deploy (Render via hook)

- Garanta `RENDER_DEPLOY_HOOK` definido em `.env`.
- Rode `./deploy.sh` (instala deps, checa sintaxe e chama o hook). O script imprime a URL dos docs via `DOCS_URL`.

## Fluxo de Git recomendado

1. Criar branch de feature: `./git-start-feature.sh nome`
2. Trabalhar e comitar: `./git-deploy.sh "mensagem"` (em feature branch ele só faz push, mostra o link do PR e não deploy)
3. Abrir PR e fazer merge na `main`
4. Na `main`, rodar `./git-post-merge-deploy.sh "mensagem"` para atualizar a main e disparar push + deploy (hook Render)
