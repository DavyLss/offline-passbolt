# offline-passbolt

A simple offline Passbolt CE stack for on-premise environments.

This repository is built for installations that must work without Internet access on the target site.

## What this is for

Use it when you need an internal secret manager that can be:
- deployed fully offline
- kept on a private network
- exposed only over internal HTTPS
- handed over with clear and repeatable steps

The goal is to provide a solid, practical base for a small team, not a full enterprise platform.

## What is included

- Passbolt CE in non-root container mode
- dedicated MariaDB container
- Docker Compose and Podman Compose deployment files
- offline image bundle preparation
- install, bootstrap, and verification scripts
- internal HTTPS support
- basic container hardening
- documentation for install, security, and acceptance

## What is not included

- Docker or Podman installation on the host
- automatic certificate issuance
- public SMTP service
- high availability
- external database
- advanced monitoring
- SSO, LDAP, or directory integration
- ready-made automated backups

## Typical use case

This stack fits a private internal Passbolt service:
- hosted on a customer network
- not exposed to the Internet
- installed from pre-exported images
- operated with internal DNS and internal TLS

## Recommended sizing

Current defaults fit a small team:
- about 20 to 30 accounts
- about 5 to 10 simultaneous active users
- standard Passbolt usage, browsing, sharing, and updating secrets

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

## Repository layout

- `compose/` - Docker Compose and Podman Compose files
- `scripts/` - preflight, import, install, bootstrap, verify, helpers
- `artifacts/` - exported images, manifests, checksums
- `certs/` - local TLS drop-in directory, not versioned
- `docs/` - architecture, security, install, egress control, acceptance

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

### 3. TLS handling

For production, provide:
- `certs/passbolt.crt`
- `certs/passbolt.key`

These should match `PASSBOLT_FQDN` and come from the customer's internal PKI when possible.

If no certificate files are present, `preflight.sh` generates a local self-signed certificate automatically.
That fallback is useful for lab, demo, or validation use. It should be replaced before production handover.

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

## Main variables

Review these values in `.env`:
- `PASSBOLT_FQDN`
- `PASSBOLT_HTTP_PORT`
- `PASSBOLT_HTTPS_PORT`
- `PASSBOLT_IMAGE`
- `MARIADB_IMAGE`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`
- `PASSBOLT_KEY_*`
- `FIRST_ADMIN_*`
- `SMTP_*`

## Security notes

- Passbolt runs in non-root mode
- internal HTTPS is required
- self-registration is disabled
- MariaDB stays on a backend-only network
- persistent data is separated for database, GPG, and JWT material
- basic hardening is applied with `no-new-privileges`, `cap_drop`, CPU and RAM limits

## No Internet egress

The repository avoids Internet downloads during installation and normal use.

Actual egress blocking still has to be enforced outside the repo, at host or network level:
- host firewall
- network ACLs
- micro-segmentation
- allow-list for required internal services only

See `docs/no-internet-egress.md`.

## Limits

This is a focused V1.

- no directory integration or SSO
- no built-in backup workflow
- no automatic certificate rotation
- production deployments should replace the self-signed TLS fallback

## Documentation

- `docs/architecture.md`
- `docs/install-offline.md`
- `docs/security.md`
- `docs/no-internet-egress.md`
- `docs/acceptance-checklist.md`
