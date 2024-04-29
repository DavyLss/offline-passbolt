# offline-passbolt

Déploiement **offline** de **Passbolt CE** pour un environnement **on-premise** sans dépendance Internet à l'installation.

## Objectif
Ce projet fournit une base reproductible pour livrer au client une instance Passbolt CE :
- **100% hors connexion** côté installation ;
- compatible **Docker Compose** et **Podman Compose** ;
- **HTTPS interne obligatoire** ;
- configuration de sécurité de base renforcée ;
- documentation, bundle offline, scripts d'installation et recette.

## Périmètre V1
### Inclus
- Passbolt CE en conteneur **non-root**
- MariaDB dédiée
- compose Docker / Podman
- préparation d'un bundle d'images offline
- scripts d'installation et de vérification
- bootstrap du premier administrateur
- documentation sécurité et checklist de validation

### Non inclus
- installation de Docker ou Podman sur l'hôte
- émission automatique de certificats
- accès Internet sortant
- SMTP externe public
- haute disponibilité
- base de données externe
- supervision avancée

## Hypothèses
- Docker ou Podman est déjà installé sur la machine cible.
- Le client fournit un **FQDN interne** et un **certificat TLS interne**.
- Aucun téléchargement n'est autorisé pendant l'installation.
- L'instance n'est pas exposée sur Internet.
- Si l'email est utilisé, il passe par un **SMTP interne**.

## Architecture résumée
- **Passbolt CE** publie l'interface web en HTTPS sur le réseau interne.
- **MariaDB** n'est jamais exposée hors du réseau de backend.
- Les certificats TLS sont fournis localement via `certs/`.
- Les conteneurs utilisent un réseau dédié ; la base reste isolée.
- Le blocage réel de la sortie Internet doit être appliqué au niveau **pare-feu hôte / ACL réseau**.

Voir aussi :
- `docs/architecture.md`
- `docs/install-offline.md`
- `docs/security.md`
- `docs/no-internet-egress.md`
- `docs/acceptance-checklist.md`

## Ressources cibles recommandées
Pour une petite équipe (jusqu'à ~20 utilisateurs, avec quelques utilisateurs actifs simultanément) :

### Hôte
- **4 vCPU**
- **8 Go RAM**
- **100 Go SSD**

### Passbolt
- **2 vCPU max**
- **3 Go RAM max**

### MariaDB
- **1 vCPU max**
- **2 Go RAM max**

## Préparation du bundle offline
Sur une machine disposant d'un accès Internet :

```bash
cp .env.example .env
$EDITOR .env
./scripts/prepare-bundle.sh
```

Ce script :
- télécharge les images définies dans `.env` ;
- les exporte dans `artifacts/images/` ;
- génère `artifacts/manifest/images.txt` ;
- génère `artifacts/checksums/SHA256SUMS`.

## Installation offline
### Docker
```bash
cp .env.example .env
$EDITOR .env
cp certs/passbolt.crt.example certs/passbolt.crt
cp certs/passbolt.key.example certs/passbolt.key
# Remplacer les exemples par les vrais certificats internes
./scripts/install.sh docker
./scripts/bootstrap-admin.sh docker
./scripts/verify.sh docker
```

### Podman
```bash
cp .env.example .env
$EDITOR .env
cp certs/passbolt.crt.example certs/passbolt.crt
cp certs/passbolt.key.example certs/passbolt.key
# Remplacer les exemples par les vrais certificats internes
./scripts/install.sh podman
./scripts/bootstrap-admin.sh podman
./scripts/verify.sh podman
```

## Variables principales à adapter
Dans `.env` :
- `PASSBOLT_FQDN` : nom DNS interne de l'instance
- `PASSBOLT_HTTP_PORT` : port HTTP exposé (pour redirection éventuelle)
- `PASSBOLT_HTTPS_PORT` : port HTTPS exposé
- `PASSBOLT_IMAGE` : image Passbolt CE
- `MARIADB_IMAGE` : image MariaDB
- `DB_*` : paramètres de base de données
- `PASSBOLT_KEY_*` : identité de la clé serveur GPG
- `FIRST_ADMIN_*` : bootstrap du premier administrateur
- `SMTP_*` : serveur mail interne, si utilisé

## Sécurité retenue en V1
- image Passbolt **non-root** ;
- HTTPS interne obligatoire ;
- base MariaDB isolée sur réseau backend ;
- inscription libre désactivée ;
- volumes persistants dédiés pour GPG / JWT / base ;
- pas d'exposition Internet ;
- dépendances externes supprimées du flux d'installation ;
- durcissement conteneur de base (`no-new-privileges`, `cap_drop`, limites CPU/RAM).

## Limites connues de la V1
- le blocage de la sortie Internet doit être appliqué par le client au niveau réseau/hôte ;
- pas d'intégration d'annuaire/SSO dans cette V1 ;
- pas de sauvegarde automatisée livrée dans la base du projet ;
- pas de rotation automatique des certificats.
