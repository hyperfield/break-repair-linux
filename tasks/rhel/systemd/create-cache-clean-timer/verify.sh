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

[[ -x /usr/local/bin/lab-cache-clean.sh ]] || die "cache-clean script is missing or not executable"
systemctl cat lab-cache-clean.service >/dev/null 2>&1 || die "service unit is missing"
systemctl cat lab-cache-clean.timer >/dev/null 2>&1 || die "timer unit is missing"
[[ "$(systemctl show -p Type --value lab-cache-clean.service)" == "oneshot" ]] || die "service type is not oneshot"
[[ "$(systemctl show -p Unit --value lab-cache-clean.timer)" == "lab-cache-clean.service" ]] || die "timer does not target lab-cache-clean.service"
systemctl cat lab-cache-clean.timer | grep -Eq '^OnBootSec=1min$' || die "timer is missing OnBootSec=1min"
systemctl cat lab-cache-clean.timer | grep -Eq '^OnUnitActiveSec=10min$' || die "timer is missing OnUnitActiveSec=10min"
[[ "$(systemctl is-enabled lab-cache-clean.timer)" == "enabled" ]] || die "timer is not enabled"
[[ "$(systemctl is-active lab-cache-clean.timer)" == "active" ]] || die "timer is not active"

info "task verified successfully"
