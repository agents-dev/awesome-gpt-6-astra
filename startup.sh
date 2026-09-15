#!/usr/bin/env bash
# Validation startup for APEX CLUB (yellow-sky build).
# Portable: bash + node/npm + python3 only. No global installs.
# Serves works/apex-club/dist in the foreground on $PORT (default 3000).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

APP_DIR="works/apex-club"
PORT="${PORT:-3000}"

timed() {
  local label="$1"; shift
  echo "==> $label: $*"
  local start end elapsed status
  start=$(date +%s)
  set +e
  "$@"
  status=$?
  set -e
  end=$(date +%s)
  elapsed=$((end - start))
  echo "---- $label done in ${elapsed}s (exit $status)"
  return $status
}

timed "install-deps" npm --prefix "$APP_DIR" install --no-audit --no-fund
timed "build" npm --prefix "$APP_DIR" run build

if [ ! -f "$APP_DIR/dist/index.html" ]; then
  echo "ERROR: build did not produce $APP_DIR/dist/index.html" >&2
  exit 1
fi

echo "==> serve: python3 -m http.server $PORT --directory $APP_DIR/dist (foreground)"
echo "---- serving APEX CLUB at http://localhost:${PORT}/ (Ctrl+C to stop)"
exec python3 -m http.server "$PORT" --directory "$APP_DIR/dist"
