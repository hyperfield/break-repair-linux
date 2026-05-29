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

require_os_family "$TASK_FAMILY"

info "verifying task result: $TASK_ID"

require_cmd blkid

[[ -f /swap.lab ]] || die "/swap.lab does not exist"
[[ "$(stat -c '%a' /swap.lab)" == "600" ]] || die "/swap.lab mode must be 0600"
[[ "$(stat -c '%s' /swap.lab)" -ge 134217728 ]] || die "/swap.lab is smaller than 128 MiB"
[[ "$(blkid -o value -s TYPE /swap.lab 2>/dev/null)" == "swap" ]] || die "/swap.lab is not initialized as swap"
swapon --noheadings --show=NAME | grep -Fxq "/swap.lab" || die "/swap.lab is not active"
grep -Eq '^/swap\.lab[[:space:]]+none[[:space:]]+swap[[:space:]]' /etc/fstab || die "/etc/fstab is missing the swap entry"

info "task verified successfully"
