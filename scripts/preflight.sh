#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  echo "Copy .env.example to .env first"
  exit 1
fi

if [ ! -f certs/passbolt.crt ] || [ ! -f certs/passbolt.key ]; then
  echo "Missing TLS certificate files in certs/passbolt.crt and certs/passbolt.key"
  exit 1
fi

chmod 644 certs/passbolt.crt certs/passbolt.key
mkdir -p data/passbolt/gpg data/passbolt/jwt data/db

echo "[+] Preflight OK"
