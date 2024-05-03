# No Internet egress

The repository is designed to avoid Internet downloads during installation and intended day-to-day operation.

## What the repository covers

- offline image bundle preparation
- no mandatory SaaS dependency
- isolated MariaDB backend network
- local deployment assets only

## What the customer must still enforce

Docker or Podman alone does not fully enforce a precise no-Internet policy while preserving internal LAN access.

The effective egress block must still be implemented with:
- host firewall rules
- network ACLs or micro-segmentation
- explicit allow-lists for required internal services only, DNS, NTP, internal SMTP if needed

## Recommended policy

Allow only:
- internal DNS
- internal NTP
- internal SMTP if required
- client access from approved internal segments to the Passbolt service

Deny:
- any outbound access to the public Internet from the host or container networks
