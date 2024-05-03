# Acceptance checklist

This checklist helps validate that an offline installation of `offline-passbolt` is usable and ready for handover.

## 1. Host prerequisites
- [ ] Docker or Podman is installed
- [ ] the internal Passbolt FQDN resolves correctly
- [ ] the instance is not exposed to the Internet
- [ ] internal TLS certificates are available, or the self-signed fallback is explicitly accepted for lab use

## 2. Offline bundle
- [ ] `.tar` archives are present in `artifacts/images/`
- [ ] `artifacts/manifest/images.txt` is coherent
- [ ] `artifacts/checksums/SHA256SUMS` is present
- [ ] checksums were verified

## 3. Configuration
- [ ] `.env` was created from `.env.example`
- [ ] `PASSBOLT_FQDN` is correct
- [ ] `DB_PASSWORD` was customized
- [ ] image tags match the delivered bundle
- [ ] TLS mode was chosen, internal certificate or self-signed lab fallback

## 4. Installation
- [ ] `./scripts/install.sh docker` or `./scripts/install.sh podman` succeeds
- [ ] the `passbolt` container is healthy
- [ ] the `passbolt-db` container is healthy

## 5. Application health
- [ ] `./scripts/verify.sh <engine>` succeeds
- [ ] `https://<PASSBOLT_FQDN>/healthcheck/status.json` responds
- [ ] the web interface is reachable from the internal network

## 6. Administrator bootstrap
- [ ] `./scripts/bootstrap-admin.sh <engine>` succeeds
- [ ] the administrator setup link is generated
- [ ] the first administrator completes registration

## 7. Security
- [ ] self-registration is disabled
- [ ] internal HTTPS is operational
- [ ] network access is limited to approved internal segments
- [ ] the no-Internet-egress plan is enforced on the host or network
- [ ] MFA policy is enabled after go-live
- [ ] production deployments do not rely on the self-signed fallback

## 8. Final acceptance criteria
- [ ] installation is achievable without Internet
- [ ] the Passbolt interface is reachable over HTTPS
- [ ] the first administrator was created
- [ ] database and cryptographic materials persist correctly
- [ ] no Internet dependency is required for intended normal use
