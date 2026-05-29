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

info "verifying repaired state: $SCENARIO_ID"

systemctl cat lab-cache-clean.timer >/dev/null 2>&1 || die "timer unit is missing"
systemctl cat lab-cache-clean.timer | grep -Eq '^OnBootSec=2min$' || die "timer is missing OnBootSec=2min"
systemctl cat lab-cache-clean.timer | grep -Eq '^OnUnitActiveSec=15min$' || die "timer is missing OnUnitActiveSec=15min"
[[ "$(systemctl is-enabled lab-cache-clean.timer)" == "enabled" ]] || die "timer is not enabled"
[[ "$(systemctl is-active lab-cache-clean.timer)" == "active" ]] || die "timer is not active"

info "repaired state confirmed"
