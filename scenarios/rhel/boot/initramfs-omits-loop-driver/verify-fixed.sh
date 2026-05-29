#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../../../.." && pwd)"

# shellcheck disable=SC1091
source "$REPO_ROOT/lib/common.sh"
# shellcheck disable=SC1091
source "$REPO_ROOT/lib/platform.sh"
# shellcheck disable=SC1091
source "$REPO_ROOT/lib/boot.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/metadata.env"

require_os_family "$SCENARIO_FAMILY"

BAD_FILE="/etc/dracut.conf.d/91-break-repair-omit-loop.conf"

info "verifying repaired state: $SCENARIO_ID"

if [[ -f "$BAD_FILE" ]]; then
  grep -Eq '^omit_drivers\+\=" loop "' "$BAD_FILE" && die "omit-driver config is still present"
fi

initramfs_contains_pattern 'loop\.ko' || die "loop driver is still missing from initramfs"
info "repaired state confirmed"
