#!/usr/bin/env bash
set -euo pipefail

# Sempre a partir da raiz do repositório
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

COMMIT_MSG="${1:-chore: deploy}"

# Status para referência
git status -sb

# Add e commit (se houver mudanças)
git add .
if git commit -m "$COMMIT_MSG"; then
  echo "Commit criado: $COMMIT_MSG"
else
  echo "Nada para commitar" >&2
fi

# Push para main
git push origin main

# Chama o deploy (usa deploy.sh existente)
./deploy.sh
