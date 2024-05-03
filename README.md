# offline-passbolt

Offline Passbolt CE stack for network-isolated, on-premise environments.

This project is built for installations that must work **without Internet access** on the target site while still keeping a strong baseline for HTTPS, secret storage, and operational handover.

## Why this project exists

Some customers need a local secret manager that can be:
- installed fully offline
- hosted only on the internal network
- integrated with internal TLS certificates
- delivered with repeatable deployment steps

The goal is not to ship a complete enterprise secret platform. The goal is to provide a **practical offline-ready Passbolt base** for small internal teams.

## What it includes

- Passbolt CE in non-root container mode
- dedicated MariaDB container
- Docker Compose and Podman Compose deployment files
- offline image bundle preparation
- install, bootstrap, and verification scripts
- internal HTTPS support
- basic container hardening
- installation, security, and acceptance documentation

## What it does not include

- Docker or Podman installation on the host
- automatic certificate issuance
- Internet egress dependencies
- public SMTP service
- high availability
- external database
- advanced monitoring stack
- SSO, LDAP, or directory integration
- ready-made automated backups

## Typical use case

This stack is intended for an **internal password and secret-sharing service**:
- hosted on a customer private network
- not exposed to the Internet
- installed from pre-exported images
- operated with internal DNS and internal TLS

## Recommended target sizing

Current compose defaults fit a **small team**:
- about 20 to 30 accounts
- about 5 to 10 simultaneous active users
- standard Passbolt usage, browsing, sharing, updating secrets

### Host
- 4 vCPU
- 8 GB RAM
- 100 GB SSD

### Passbolt
- 2 vCPU max
- 3 GB RAM max

### MariaDB
- 1 vCPU max
- 2 GB RAM max

## Repository structure

- `compose/`, Docker Compose and Podman Compose definitions
- `scripts/`, preflight, image import, install, bootstrap, verify, and helper scripts
- `artifacts/`, exported images, manifests, and checksums
- `certs/`, local TLS certificate drop-in directory, not versioned
- `docs/`, architecture, security, offline installation, egress control, and acceptance docs

## Quick start

### 1. Prepare the offline bundle on a connected machine

```bash
cp .env.example .env
$EDITOR .env
./scripts/prepare-bundle.sh
```

Then transfer the repository and image archives to the target site.

### 2. Prepare the target configuration

```bash
cp .env.example .env
$EDITOR .env
```

### 3. TLS certificate handling

Recommended production mode:
- provide `certs/passbolt.crt`
- provide `certs/passbolt.key`
- use an internal certificate matching `PASSBOLT_FQDN`

Fallback lab mode:
- if no certificate files are present, `preflight.sh` generates a **local self-signed certificate** automatically
- this is suitable for tests, demos, and isolated validation
- replace it before production handover

### 4. Install

#### Docker

```bash
./scripts/install.sh docker
./scripts/bootstrap-admin.sh docker
./scripts/verify.sh docker
```

#### Podman

```bash
./scripts/install.sh podman
./scripts/bootstrap-admin.sh podman
./scripts/verify.sh podman
```

## Main variables to review

In `.env`:
- `PASSBOLT_FQDN`, internal DNS name of the instance
- `PASSBOLT_HTTP_PORT`, exposed HTTP port
- `PASSBOLT_HTTPS_PORT`, exposed HTTPS port
- `PASSBOLT_IMAGE`, Passbolt CE image
- `MARIADB_IMAGE`, MariaDB image
- `DB_NAME`, `DB_USER`, `DB_PASSWORD`, database parameters
- `PASSBOLT_KEY_*`, Passbolt server GPG key identity settings
- `FIRST_ADMIN_*`, first administrator bootstrap values
- `SMTP_*`, internal mail server settings if used

## Security model, V1

- Passbolt non-root image
- internal HTTPS required
- MariaDB isolated on a backend-only network
- self-registration disabled
- dedicated persistent volumes for GPG, JWT, and database data
- no Internet exposure
- no external download dependency during installation
- basic container hardening, `no-new-privileges`, `cap_drop`, CPU and RAM limits

## No Internet egress

The project is designed to work without Internet access during installation and normal operation.

However, the **actual enforcement** of blocked Internet egress must still be applied by the customer at host or network level:
- host firewall
- network ACLs
- micro-segmentation
- allow-list of required internal services only, DNS, NTP, internal SMTP if needed

See `docs/no-internet-egress.md`.

## Known V1 limits

- outbound Internet blocking must be enforced outside the repo, on host or network controls
- no directory integration or SSO in this V1
- no automated backup workflow included by default
- no automatic certificate rotation
- production use should replace the self-signed fallback with customer PKI certificates

## Documentation

- `docs/architecture.md`
- `docs/install-offline.md`
- `docs/security.md`
- `docs/no-internet-egress.md`
- `docs/acceptance-checklist.md`

## Recommended next steps after V1

- add customer operations runbooks
- define backup and restore procedures
- document offline upgrade workflows
- add extra hardening and governance controls
- integrate MFA, SSO, or directory services when required
