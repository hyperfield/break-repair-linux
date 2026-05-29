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

LAB_USER="labanalyst"

info "verifying repaired state: $SCENARIO_ID"

id "$LAB_USER" >/dev/null 2>&1 || die "user $LAB_USER does not exist"
[[ "$(stat -c '%U:%G %a' "/home/$LAB_USER")" == "$LAB_USER:$LAB_USER 700" ]] || \
  die "home directory ownership or mode is still incorrect"

info "repaired state confirmed"
