#!/bin/sh
if curl -sf http://localhost:3141/+api > /dev/null 2>&1; then
  exit 0
else
  echo "devpi API not responding on port 3141"
  exit 1
fi
