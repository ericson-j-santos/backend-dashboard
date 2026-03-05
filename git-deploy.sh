#!/usr/bin/env bash
set -euo pipefail

# Sempre a partir da raiz do repositório
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

COMMIT_MSG="${1:-chore: deploy}"

# Garante entradas essenciais no .gitignore
ensure_ignore() {
  local pattern="$1"
  grep -qx "$pattern" .gitignore || echo "$pattern" >> .gitignore
}

ensure_ignore ".env"
ensure_ignore ".env.local"
ensure_ignore "*.db"
ensure_ignore "dashboard.db"

# Status para referência
git status -sb

# Add e commit (se houver mudanças)
git add .
if git commit -m "$COMMIT_MSG"; then
  echo "Commit criado: $COMMIT_MSG"
else
  echo "Nada para commitar; abortando push/deploy." >&2
  exit 0
fi

# Push para main
git push origin main

# Chama o deploy (usa deploy.sh existente)
./deploy.sh
