#!/bin/sh
CURRENT=$(/usr/bin/container-version)
LATEST=$(/usr/bin/container-latest)
case "${LATEST}" in
  "${CURRENT}"*)
    exit 0
    ;;
  *)
    echo "Version mismatch: current=${CURRENT} latest=${LATEST}"
    exit 1
    ;;
esac
