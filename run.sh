#!/usr/bin/env bash
set -euo pipefail

# Always operate from the repo root
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [[ -d "venv" ]]; then
	source "venv/bin/activate"
else
	python3 -m venv venv
	source "venv/bin/activate"
	pip install --upgrade pip
	pip install -r requirements.txt
fi

export PYTHONPATH="$ROOT_DIR"

# Pick a free port near the desired base (default 8000, override with PORT)
BASE_PORT="${PORT:-8000}"
FOUND_PORT=$(python - "$BASE_PORT" <<'PY'
import socket
import sys

base = int(sys.argv[1])
for port in range(base, base + 20):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.bind(("0.0.0.0", port))
        except OSError:
            continue
        sys.stdout.write(str(port))
        sys.exit(0)

sys.exit(1)
PY
)

if [[ -z "$FOUND_PORT" ]]; then
  echo "No free port found in range $BASE_PORT-$((BASE_PORT+19))" >&2
  exit 1
fi

echo "Starting on port $FOUND_PORT" >&2
exec uvicorn app.main:app --host 0.0.0.0 --port "$FOUND_PORT" --reload
