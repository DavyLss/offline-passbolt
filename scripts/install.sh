#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-docker}"

source ./scripts/lib-env.sh
load_env_file ./.env

compose_up() {
  if [ "$MODE" = "docker" ]; then
    if docker compose version >/dev/null 2>&1; then
      docker compose -f compose/docker-compose.yml up -d
    elif command -v docker-compose >/dev/null 2>&1; then
      docker-compose -f compose/docker-compose.yml up -d
    else
      echo "Docker Compose not found (need 'docker compose' plugin or 'docker-compose')."
      exit 1
    fi
  elif [ "$MODE" = "podman" ]; then
    podman compose -f compose/podman-compose.yml up -d
  else
    echo "Unsupported mode: ${MODE}"
    exit 1
  fi
}

./scripts/preflight.sh
./scripts/load-images.sh "${MODE}"
compose_up
./scripts/wait-for-passbolt.sh "${MODE}"

echo
echo "Installation OK."
echo "Next: ./scripts/bootstrap-admin.sh ${MODE}"
