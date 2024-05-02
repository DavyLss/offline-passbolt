#!/usr/bin/env bash
set -euo pipefail

ENGINE="${1:-docker}"
source ./scripts/lib-env.sh
load_env_file ./.env

"$ENGINE" exec -u www-data passbolt /usr/share/php/passbolt/bin/cake passbolt register_user -u "${FIRST_ADMIN_EMAIL}" -f "${FIRST_ADMIN_FIRSTNAME}" -l "${FIRST_ADMIN_LASTNAME}" -r admin
