# Security

## Paramètres retenus
- image Passbolt non-root
- HTTPS interne obligatoire
- auto-inscription désactivée
- MariaDB isolée sur un réseau backend interne
- volumes persistants séparés pour GPG, JWT et base de données
- `no-new-privileges` sur les conteneurs
- `cap_drop: ALL` sur les conteneurs
- limites CPU/RAM sur Passbolt et MariaDB

## Recommandations complémentaires
- imposer une politique MFA côté Passbolt après bootstrap
- utiliser un certificat interne signé par l'AC de l'entreprise
- limiter l'accès réseau aux seuls segments internes autorisés
- sauvegarder régulièrement la base, les clés GPG et les secrets JWT
- ne jamais exposer l'instance sur Internet
