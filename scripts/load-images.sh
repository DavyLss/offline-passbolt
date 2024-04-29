#!/usr/bin/env bash
set -euo pipefail

ENGINE="${1:-docker}"
IMAGE_DIR="artifacts/images"

shopt -s nullglob
images=("$IMAGE_DIR"/*.tar)
if [ ${#images[@]} -eq 0 ]; then
  echo "No offline images found in $IMAGE_DIR"
  exit 1
fi

for image in "${images[@]}"; do
  echo "[+] Loading $image"
  "$ENGINE" load -i "$image"
done
