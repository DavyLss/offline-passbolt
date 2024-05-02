#!/usr/bin/env bash
set -euo pipefail

ENGINE="${1:-docker}"
source ./scripts/lib-env.sh
load_env_file ./.env

echo "[+] HTTPS healthcheck"
curl -kfsS "https://${PASSBOLT_FQDN}:${PASSBOLT_HTTPS_PORT}/healthcheck/status.json"
echo

echo "[+] Container status"
if [ "$ENGINE" = "docker" ]; then
  docker ps --format 'table {{.Names}}\t{{.Status}}'
else
  podman ps --format 'table {{.Names}}\t{{.Status}}'
fi
