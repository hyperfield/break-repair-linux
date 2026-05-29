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

systemctl cat lab-cache-clean.timer >/dev/null 2>&1 || die "timer unit is missing"
[[ "$(systemctl is-enabled lab-cache-clean.timer)" == "masked" ]] || die "timer is not masked"

info "broken state confirmed"
