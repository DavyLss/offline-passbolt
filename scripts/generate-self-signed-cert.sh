#!/usr/bin/env bash
set -euo pipefail

source ./scripts/lib-env.sh
load_env_file ./.env

if ! command -v openssl >/dev/null 2>&1; then
  echo "openssl is required to generate a self-signed certificate" >&2
  exit 1
fi

mkdir -p certs

openssl req -x509 -nodes -newkey rsa:4096 \
  -keyout certs/passbolt.key \
  -out certs/passbolt.crt \
  -sha256 \
  -days 825 \
  -subj "/CN=${PASSBOLT_FQDN}" \
  -addext "subjectAltName=DNS:${PASSBOLT_FQDN}"

chmod 600 certs/passbolt.key
chmod 644 certs/passbolt.crt

echo "[+] Generated self-signed certificate for ${PASSBOLT_FQDN}"
echo "[!] For production, replace certs/passbolt.crt and certs/passbolt.key with internal PKI certificates."
