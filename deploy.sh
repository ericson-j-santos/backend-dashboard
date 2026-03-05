#!/usr/bin/env bash
set -euo pipefail

# Always operate from repo root
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# Carrega variáveis de ambiente locais, se existirem
if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi

# Docs URL (pode sobrescrever com DOCS_URL)
DOCS_URL="${DOCS_URL:-https://backend-dashboard-gvl3.onrender.com/docs#/}"

# Ensure venv and deps
if [[ -d "venv" ]]; then
  source "venv/bin/activate"
else
  python3 -m venv venv
  source "venv/bin/activate"
  pip install --upgrade pip
fi
pip install -r requirements.txt

# Quick sanity: fail fast on syntax errors
python -m compileall app

# Trigger Render deploy via hook if provided
if [[ -n "${RENDER_DEPLOY_HOOK:-}" ]]; then
  echo "Triggering remote deploy via Render hook..."
  curl -fsSL -X POST "$RENDER_DEPLOY_HOOK" && echo "Deploy hook triggered"
else
  echo "Set RENDER_DEPLOY_HOOK to your Render deploy hook URL to trigger a remote deploy." >&2
fi

echo "Docs: $DOCS_URL"
