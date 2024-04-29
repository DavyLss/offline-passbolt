#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-docker}"

./scripts/preflight.sh
./scripts/load-images.sh "${MODE}"

if [ "${MODE}" = "docker" ]; then
  docker compose -f compose/docker-compose.yml up -d
elif [ "${MODE}" = "podman" ]; then
  podman compose -f compose/podman-compose.yml up -d
else
  echo "Unsupported mode: ${MODE}"
  exit 1
fi

./scripts/wait-for-passbolt.sh "${MODE}"

echo
echo "Installation OK."
echo "Next: ./scripts/bootstrap-admin.sh ${MODE}"
