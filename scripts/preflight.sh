#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  echo "Copy .env.example to .env first"
  exit 1
fi

source ./scripts/lib-env.sh
load_env_file ./.env

if [ ! -f certs/passbolt.crt ] || [ ! -f certs/passbolt.key ]; then
  echo "[!] Missing TLS certificate files, generating a local self-signed certificate for ${PASSBOLT_FQDN}"
  ./scripts/generate-self-signed-cert.sh
fi

chmod 644 certs/passbolt.crt
chmod 600 certs/passbolt.key
mkdir -p data/passbolt/gpg data/passbolt/jwt data/db

echo "[+] Preflight OK"
