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

SUPPORT_FILE="/etc/dracut.conf.d/90-break-repair-loop.conf"
BAD_FILE="/etc/dracut.conf.d/91-break-repair-omit-loop.conf"

info "verifying broken state: $SCENARIO_ID"

[[ -f "$SUPPORT_FILE" ]] || die "support dracut config is missing"
[[ -f "$BAD_FILE" ]] || die "omit-driver dracut config is missing"
initramfs_contains_pattern 'loop\.ko' && die "loop driver is unexpectedly present in initramfs"

info "broken state confirmed"
