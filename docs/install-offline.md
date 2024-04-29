# Installation offline

1. Copier le dépôt sur la machine cible.
2. Vérifier que Docker ou Podman est déjà installé.
3. Copier `.env.example` en `.env` puis adapter les variables.
4. Fournir les certificats internes dans `certs/passbolt.crt` et `certs/passbolt.key`.
5. Déposer les images exportées dans `artifacts/images/`.
6. Lancer `./scripts/install.sh docker` ou `./scripts/install.sh podman`.
7. Bootstrapper le premier administrateur avec `./scripts/bootstrap-admin.sh <engine>`.
8. Vérifier avec `./scripts/verify.sh <engine>`.
