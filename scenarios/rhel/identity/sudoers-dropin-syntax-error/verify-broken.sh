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

DROP_IN="/etc/sudoers.d/99-break-repair-syntax"

require_cmd visudo

[[ -f "$DROP_IN" ]] || die "expected sudoers drop-in is missing"
grep -Fq "NOPASSWD /usr/bin/passwd root" "$DROP_IN" || die "broken sudoers line is missing"
visudo -cf /etc/sudoers >/dev/null 2>&1 && die "sudoers unexpectedly validates"

info "broken state confirmed"
