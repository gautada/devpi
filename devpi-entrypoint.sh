#!/bin/sh
set -e

DATA_DIR=/mnt/volumes/data
DEVPI=/opt/devpi/bin/devpi-server
DEVPI_CLIENT=/opt/devpi/bin/devpi

# Initialize devpi on first run
if [ ! -f "${DATA_DIR}/.nodeinfo" ]; then
  echo "[devpi] Initializing data directory..."
  /opt/devpi/bin/devpi-init --serverdir "${DATA_DIR}"

  echo "[devpi] Starting server temporarily for index setup..."
  "$DEVPI" --serverdir "${DATA_DIR}" --host 127.0.0.1 --port 3141 &
  SERVER_PID=$!

  # Wait for server to become ready (max 30s)
  i=0
  while ! curl -sf http://127.0.0.1:3141/+api > /dev/null 2>&1; do
    sleep 1
    i=$((i + 1))
    if [ "$i" -ge 30 ]; then
      echo "[devpi] ERROR: server did not start within 30 seconds" >&2
      kill "$SERVER_PID" 2>/dev/null || true
      exit 1
    fi
  done

  echo "[devpi] Creating gautada/dev private index..."
  "$DEVPI_CLIENT" use http://127.0.0.1:3141
  "$DEVPI_CLIENT" login root --password=''
  "$DEVPI_CLIENT" user -c gautada email=admin@example.com password=''
  "$DEVPI_CLIENT" login gautada --password=''
  "$DEVPI_CLIENT" index -c dev bases=root/pypi || true
  "$DEVPI_CLIENT" logoff

  echo "[devpi] Stopping temporary server..."
  kill "$SERVER_PID"
  wait "$SERVER_PID" 2>/dev/null || true
  echo "[devpi] Index setup complete."
fi

exec "$DEVPI" \
  --serverdir "${DATA_DIR}" \
  --host 0.0.0.0 \
  --port 3141
