#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../../../.." && pwd)"

# shellcheck disable=SC1091
source "$REPO_ROOT/lib/common.sh"
# shellcheck disable=SC1091
source "$REPO_ROOT/lib/platform.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/metadata.env"

require_os_family "$SCENARIO_FAMILY"

LAB_USER="labbackup"

info "verifying repaired state: $SCENARIO_ID"

id "$LAB_USER" >/dev/null 2>&1 || die "user $LAB_USER does not exist"
shadow_expire="$(getent shadow "$LAB_USER" | cut -d: -f8)"
[[ -z "$shadow_expire" || "$shadow_expire" == "-1" ]] || die "account is still expired"

info "repaired state confirmed"
