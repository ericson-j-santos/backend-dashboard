#!/usr/bin/env bash
set -euo pipefail

# Sempre a partir da raiz do repositório
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

COMMIT_MSG="${1:-chore: deploy}"

BRANCH="$(git rev-parse --abbrev-ref HEAD)"

# Mensagem de fluxo recomendado
echo "Fluxo: trabalhar em branch de feature, abrir PR, merge na main e só então deploy na main." >&2

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

# Push para a branch atual
git push origin "$BRANCH"

# Só dispara deploy automático se estivermos na main
if [[ "$BRANCH" == "main" ]]; then
  echo "Na main: disparando deploy." >&2
  ./deploy.sh
else
  echo "Branch $BRANCH pushada." >&2
  echo "Abra PR: https://github.com/ericson-j-santos/backend-dashboard/compare/main...$BRANCH" >&2
  echo "Depois do merge na main, rode git-deploy.sh na main para disparar o deploy." >&2
fi
