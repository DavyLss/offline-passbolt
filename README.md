# offline-passbolt

Déploiement **offline** de **Passbolt CE** pour un environnement **on-premise** sans dépendance Internet à l'installation.

## Objectif
Ce projet fournit une base reproductible pour livrer au client une instance **Passbolt CE** :
- **100% hors connexion** côté installation ;
- compatible **Docker Compose** et **Podman Compose** ;
- **HTTPS interne obligatoire** ;
- configuration de sécurité de base renforcée ;
- bundle d'images offline, scripts d'installation, documentation et recette.

## Cas d'usage visé
Cette stack est pensée pour un **gestionnaire de secrets interne** :
- hébergé dans le réseau privé du client ;
- sans exposition Internet ;
- avec certificats TLS internes ;
- avec dépendances réseau limitées au strict nécessaire ;
- installable sans téléchargement supplémentaire sur le site cible.

## Périmètre V1
### Inclus
- Passbolt CE en conteneur **non-root**
- MariaDB dédiée
- compatibilité **Docker Compose** / **Podman Compose**
- préparation d'un bundle d'images offline
- scripts d'installation, bootstrap et vérification
- bootstrap du premier administrateur
- documentation sécurité
- checklist de validation

### Non inclus
- installation de Docker ou Podman sur l'hôte
- émission automatique de certificats
- accès Internet sortant
- SMTP externe public
- haute disponibilité
- base de données externe
- supervision avancée
- SSO / LDAP / annuaire
- sauvegardes automatisées prêtes à l'emploi

## Hypothèses
- Docker ou Podman est déjà installé sur la machine cible.
- Le client fournit un **FQDN interne**.
- Le client fournit un **certificat TLS interne** valide pour ce FQDN.
- Aucun téléchargement n'est autorisé pendant l'installation.
- L'instance n'est pas exposée sur Internet.
- Si l'email est utilisé, il passe par un **SMTP interne**.

## Architecture résumée
- **Passbolt CE** publie l'interface web en HTTPS sur le réseau interne.
- **MariaDB** n'est jamais exposée hors du réseau de backend.
- Les certificats TLS sont fournis localement via `certs/`.
- Les conteneurs utilisent un réseau dédié ; la base reste isolée.
- Le blocage réel de la sortie Internet doit être appliqué au niveau **pare-feu hôte / ACL réseau**.

## Ressources cibles recommandées
Le sizing V1 actuellement intégré dans les compose correspond à une **petite équipe** :
- environ **20 à 30 comptes** au total ;
- environ **5 à 10 utilisateurs actifs simultanément** ;
- usage standard Passbolt : consultation, partage, mise à jour de secrets, sans charge inhabituelle.

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

### Lecture rapide
- profil actuel = **petite équipe / PME légère** ;
- adapté à plusieurs sessions web simultanées ;
- si le client vise une équipe plus large ou une simultanéité plus forte, prévoir un profil supérieur.

## Structure du dépôt
- `compose/` : définitions Docker Compose / Podman Compose
- `scripts/` : préflight, import d'images, installation, bootstrap admin, vérification
- `artifacts/` : images exportées, manifest, checksums
- `certs/` : certificats internes à déposer localement
- `docs/` : architecture, sécurité, installation offline, egress control, recette

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

Ensuite, transférer le dépôt et les archives d'images sur le site client.

## Installation offline
### 1. Préparer la configuration
```bash
cp .env.example .env
$EDITOR .env
```

### 2. Déposer les certificats internes
```bash
cp certs/passbolt.crt.example certs/passbolt.crt
cp certs/passbolt.key.example certs/passbolt.key
# remplacer ensuite les fichiers example par les vrais certificats internes
```

### 3. Lancer l'installation
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

## Variables principales à adapter
Dans `.env` :
- `PASSBOLT_FQDN` : nom DNS interne de l'instance
- `PASSBOLT_HTTP_PORT` : port HTTP exposé
- `PASSBOLT_HTTPS_PORT` : port HTTPS exposé
- `PASSBOLT_IMAGE` : image Passbolt CE
- `MARIADB_IMAGE` : image MariaDB
- `DB_NAME`, `DB_USER`, `DB_PASSWORD` : paramètres de base de données
- `PASSBOLT_KEY_*` : identité de la clé serveur GPG
- `FIRST_ADMIN_*` : bootstrap du premier administrateur
- `SMTP_*` : serveur mail interne, si utilisé

## Sécurité retenue en V1
- image Passbolt **non-root** ;
- HTTPS interne obligatoire ;
- base MariaDB isolée sur réseau backend ;
- auto-inscription désactivée ;
- volumes persistants dédiés pour GPG / JWT / base ;
- pas d'exposition Internet ;
- dépendances externes supprimées du flux d'installation ;
- durcissement conteneur de base (`no-new-privileges`, `cap_drop`, limites CPU/RAM).

## Zéro sortie Internet
Le projet est pensé pour fonctionner sans accès Internet pendant l'installation et l'usage nominal.

Cependant, le **blocage réel de l'egress Internet** doit être appliqué côté client :
- pare-feu hôte ;
- ACL réseau ;
- micro-segmentation ;
- autorisation limitée aux services internes nécessaires (DNS, NTP, SMTP interne si utilisé).

Voir : `docs/no-internet-egress.md`

## Validation
Une checklist de recette est fournie ici :
- `docs/acceptance-checklist.md`

Elle permet de vérifier notamment :
- les prérequis hôte ;
- l'intégrité du bundle offline ;
- la santé de Passbolt ;
- le bootstrap du premier administrateur ;
- le bon fonctionnement HTTPS ;
- l'absence de dépendance Internet pour le fonctionnement attendu.

## Limites connues de la V1
- le blocage de la sortie Internet doit être appliqué par le client au niveau réseau/hôte ;
- pas d'intégration d'annuaire/SSO dans cette V1 ;
- pas de sauvegarde automatisée livrée dans la base du projet ;
- pas de rotation automatique des certificats ;
- validation runtime réelle à exécuter sur une machine disposant de Docker ou Podman.

## Documentation complémentaire
- `docs/architecture.md`
- `docs/install-offline.md`
- `docs/security.md`
- `docs/no-internet-egress.md`
- `docs/acceptance-checklist.md`

## Suite recommandée
Après validation de la V1, les évolutions naturelles sont :
- guide d'exploitation client ;
- procédure de sauvegarde/restauration ;
- procédure d'upgrade offline ;
- durcissement complémentaire ;
- intégration éventuelle MFA/SSO/annuaire selon le besoin du client.
