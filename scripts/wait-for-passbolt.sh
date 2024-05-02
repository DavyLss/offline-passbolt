#!/usr/bin/env bash
set -euo pipefail

source ./scripts/lib-env.sh
load_env_file ./.env

for i in $(seq 1 90); do
  if curl -kfsS "https://${PASSBOLT_FQDN}:${PASSBOLT_HTTPS_PORT}/healthcheck/status.json" >/dev/null 2>&1; then
    echo "[+] Passbolt ready"
    exit 0
  fi
  echo "[.] Waiting for Passbolt ($i/90)"
  sleep 10
done

echo "[-] Passbolt not ready in time"
exit 1
