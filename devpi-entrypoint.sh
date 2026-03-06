#!/bin/sh
set -e

DATA_DIR=/mnt/volumes/data

# Initialize devpi on first run
if [ ! -f "${DATA_DIR}/.nodeinfo" ]; then
  /opt/devpi/bin/devpi-init --serverdir "${DATA_DIR}"
fi

exec /opt/devpi/bin/devpi-server \
  --serverdir "${DATA_DIR}" \
  --host 0.0.0.0 \
  --port 3141
