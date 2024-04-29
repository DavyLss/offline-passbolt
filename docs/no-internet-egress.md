# Zéro sortie Internet

Le projet est conçu pour fonctionner **sans téléchargement ni dépendance Internet** au moment de l'installation et de l'exploitation nominale.

## Ce que le dépôt couvre
- bundle d'images offline
- aucune dépendance SaaS obligatoire
- base MariaDB isolée
- réseau backend Docker/Podman marqué `internal`

## Ce que le client doit encore faire
Docker/Podman ne garantit pas à lui seul une interdiction fine de sortie Internet tout en autorisant l'accès LAN.
Le **blocage effectif de l'egress Internet** doit être appliqué :
- au niveau du pare-feu de l'hôte ;
- ou via ACL réseau / micro-segmentation ;
- en autorisant seulement les flux internes explicitement nécessaires (DNS interne, NTP interne, SMTP interne si utilisé).

## Politique recommandée
Autoriser seulement :
- DNS interne
- NTP interne
- SMTP interne si nécessaire
- accès HTTPS/HTTP depuis les postes clients internes vers Passbolt

Refuser :
- toute sortie vers Internet public depuis l'hôte ou les sous-réseaux de conteneurs.
