# Security

## Security choices in V1

- Passbolt non-root image
- internal HTTPS required
- self-registration disabled
- MariaDB isolated on an internal backend network
- separate persistent volumes for GPG, JWT, and database data
- `no-new-privileges` on containers
- `cap_drop: ALL` on containers
- CPU and RAM limits on Passbolt and MariaDB

## Additional recommendations

- require MFA in Passbolt after bootstrap
- use an internal CA-signed certificate for production
- limit network access to approved internal segments only
- back up the database, GPG keys, and JWT secrets regularly
- never expose the instance to the public Internet
- treat the self-signed certificate fallback as non-production only
