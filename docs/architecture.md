# Architecture

## Summary

The stack provides a small, internal Passbolt deployment for customers who need local secret management without Internet dependency on the target site.

## Main elements

- Passbolt CE in non-root container mode
- dedicated MariaDB backend
- internal HTTPS exposure only
- local persistent data for database, GPG material, and JWT material
- fully offline image-based installation

## TLS model

- production mode expects internal PKI certificates provided locally
- fallback mode can generate a self-signed certificate for lab or validation use
- the repository does not version certificate material
