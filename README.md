# offline-passbolt

<p align="center">
  <strong>Offline Passbolt CE stack for on-premise secret management</strong>
</p>

<p align="center">
  Small, focused, and built for environments where installation has to work without Internet access.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/status-ready%20for%20review-8b5cf6?style=flat-square" alt="status" />
  <img src="https://img.shields.io/badge/offline-ready-111827?style=flat-square" alt="offline ready" />
  <img src="https://img.shields.io/badge/Passbolt-CE-16a34a?style=flat-square" alt="Passbolt CE" />
  <img src="https://img.shields.io/badge/Database-MariaDB-1F305F?style=flat-square&logo=mariadb&logoColor=white" alt="MariaDB" />
  <img src="https://img.shields.io/badge/TLS-internal%20HTTPS-0f766e?style=flat-square" alt="TLS" />
  <img src="https://img.shields.io/badge/license-MIT-22c55e?style=flat-square" alt="license" />
</p>

<p align="center">
  <sub>Made for private deployments, offline delivery, and straightforward operations.</sub>
</p>

---

## Overview

This project provides a small internal Passbolt base for teams that need a private secret manager without depending on Internet access at install time.

## Highlights

- fully offline installation flow
- Passbolt CE in non-root container mode
- dedicated MariaDB backend
- internal HTTPS support
- local self-signed fallback for lab or validation use
- simple deployment with Docker Compose or Podman Compose

## Typical use case

This stack fits small internal deployments where Passbolt needs to stay on a private network, use internal DNS and TLS, and remain easy to hand over to a customer or operations team.

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

## Recommended sizing

Current defaults fit a small team:

| Component | Sizing |
|---|---|
| Host | 4 vCPU, 8 GB RAM, 100 GB SSD |
| Passbolt | 2 vCPU max, 3 GB RAM max |
| MariaDB | 1 vCPU max, 2 GB RAM max |
| Team size | about 20 to 30 accounts, 5 to 10 active users |

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

These files should match `PASSBOLT_FQDN` and ideally come from the customer's internal PKI.

If no certificate files are present, `preflight.sh` generates a local self-signed certificate automatically.
That fallback is useful for lab, demo, or validation use, but it should be replaced before production handover.

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

This is a focused V1:
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
