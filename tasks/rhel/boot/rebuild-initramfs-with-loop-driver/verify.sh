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

require_os_family "$TASK_FAMILY"

DRACUT_FILE="/etc/dracut.conf.d/90-lab-loop.conf"

info "verifying task result: $TASK_ID"

[[ -f "$DRACUT_FILE" ]] || die "dracut config snippet is missing"
grep -Eq '^add_drivers\+\=" loop "' "$DRACUT_FILE" || die "dracut config does not add the loop driver"
initramfs_contains_pattern 'loop\.ko' || die "current initramfs does not contain the loop driver"

info "task verified successfully"
