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

BAD_UUID="11111111-2222-3333-4444-555555555555"

info "verifying broken state: $SCENARIO_ID"

entry_count="$(awk '$2 == "/mnt/bootrepair" {count++} END {print count + 0}' /etc/fstab)"
[[ "$entry_count" -eq 1 ]] || die "expected exactly one broken /etc/fstab entry for /mnt/bootrepair"
entry="$(awk '$2 == "/mnt/bootrepair" {print $1 "|" $3 "|" $4}' /etc/fstab)"
[[ "${entry%%|*}" == "UUID=$BAD_UUID" ]] || die "broken UUID is missing"
printf '%s\n' "${entry##*|}" | grep -Eq '(^|,)nofail($|,)' && die "nofail is unexpectedly present"

info "broken state confirmed"
