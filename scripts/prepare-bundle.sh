#!/usr/bin/env bash
set -euo pipefail

source ./.env
mkdir -p artifacts/images artifacts/manifest artifacts/checksums

docker pull "${PASSBOLT_IMAGE}"
docker pull "${MARIADB_IMAGE}"

docker save -o "artifacts/images/passbolt-ce-non-root.tar" "${PASSBOLT_IMAGE}"
docker save -o "artifacts/images/mariadb-10.11.tar" "${MARIADB_IMAGE}"

cat > artifacts/manifest/images.txt <<MANIFEST
${PASSBOLT_IMAGE}
${MARIADB_IMAGE}
MANIFEST

(
  cd artifacts/images
  sha256sum *.tar > ../checksums/SHA256SUMS
)
