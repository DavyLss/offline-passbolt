# Offline installation

1. Copy the repository to the target host.
2. Confirm Docker or Podman is already installed.
3. Copy `.env.example` to `.env` and adjust values.
4. Optionally provide `certs/passbolt.crt` and `certs/passbolt.key` if internal PKI certificates are available.
5. Copy exported images to `artifacts/images/`.
6. Run `./scripts/install.sh docker` or `./scripts/install.sh podman`.
7. If no TLS files were provided, the preflight step generates a local self-signed certificate matching `PASSBOLT_FQDN`.
8. Bootstrap the first administrator with `./scripts/bootstrap-admin.sh <engine>`.
9. Validate with `./scripts/verify.sh <engine>`.
