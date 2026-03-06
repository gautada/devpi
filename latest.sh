#!/bin/sh
curl -sSf https://pypi.org/pypi/devpi-server/json \
  | jq -r '.info.version' \
  | tr -d '[:space:]'
