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

info "verifying broken state: $SCENARIO_ID"

DROP_IN="/etc/ssh/sshd_config.d/99-break-repair-invalid.conf"

require_cmd sshd

[[ -f "$DROP_IN" ]] || die "expected sshd drop-in is missing"
grep -Fq "ThisDirectiveDoesNotExist" "$DROP_IN" || die "invalid directive is missing"
sshd -t >/dev/null 2>&1 && die "sshd configuration unexpectedly validates"

info "broken state confirmed"
