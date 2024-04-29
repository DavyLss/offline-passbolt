# Architecture

- Passbolt CE déployé en image non-root.
- MariaDB dédiée et non exposée hors du réseau backend.
- HTTPS interne obligatoire avec certificats fournis localement.
- Installation 100% offline via bundle d'images exportées.
- Aucun service externe obligatoire pour le fonctionnement de base.
