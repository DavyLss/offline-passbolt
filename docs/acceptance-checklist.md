# Checklist de recette / validation

## 1. Pré-requis hôte
- [ ] Docker ou Podman est installé.
- [ ] Le FQDN interne de Passbolt est résolu correctement.
- [ ] L'instance n'est pas exposée sur Internet.
- [ ] Les certificats TLS internes sont disponibles.

## 2. Bundle offline
- [ ] Les archives `.tar` sont présentes dans `artifacts/images/`.
- [ ] `artifacts/manifest/images.txt` est cohérent.
- [ ] `artifacts/checksums/SHA256SUMS` est présent.
- [ ] Les checksums ont été vérifiés.

## 3. Configuration
- [ ] `.env` a été créé.
- [ ] `PASSBOLT_FQDN` est correct.
- [ ] `DB_PASSWORD` a été personnalisé.
- [ ] Les certificats internes ont été déposés.
- [ ] Les tags d'images correspondent au bundle.

## 4. Installation
- [ ] `./scripts/install.sh docker` ou `./scripts/install.sh podman` réussit.
- [ ] Le conteneur `passbolt` est sain.
- [ ] Le conteneur `passbolt-db` est sain.

## 5. Santé applicative
- [ ] `./scripts/verify.sh <engine>` réussit.
- [ ] `https://<PASSBOLT_FQDN>/healthcheck/status.json` répond.
- [ ] L'interface web est accessible depuis le réseau interne.

## 6. Bootstrap administrateur
- [ ] `./scripts/bootstrap-admin.sh <engine>` réussit.
- [ ] Le lien d'initialisation administrateur est généré.
- [ ] Le premier administrateur finalise son enregistrement.

## 7. Sécurité
- [ ] L'auto-inscription est désactivée.
- [ ] HTTPS interne est opérationnel.
- [ ] Les accès réseau sont limités aux segments internes autorisés.
- [ ] Le plan de blocage egress Internet est appliqué côté hôte / réseau.
- [ ] Une politique MFA est activée après mise en service.

## 8. Critères d'acceptation finaux
- [ ] installation réalisable sans Internet ;
- [ ] interface Passbolt accessible en HTTPS ;
- [ ] premier administrateur créé ;
- [ ] base et clés persistées correctement ;
- [ ] aucune dépendance Internet requise pour l'usage nominal prévu.
