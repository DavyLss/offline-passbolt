#!/usr/bin/env bash
set -euo pipefail

ENGINE="${1:-docker}"
source ./.env

"$ENGINE" exec passbolt su -m -c "/usr/share/php/passbolt/bin/cake passbolt register_user -u ${FIRST_ADMIN_EMAIL} -f ${FIRST_ADMIN_FIRSTNAME} -l ${FIRST_ADMIN_LASTNAME} -r admin" -s /bin/sh www-data
