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

systemctl cat lab-api.service >/dev/null 2>&1 || die "lab-api.service does not exist"
systemctl cat lab-api.service | grep -Eq '^ExecStart=/usr/local/bin/lab-api-broken.sh$' || die "broken ExecStart is missing"
[[ "$(systemctl is-active lab-api.service)" != "active" ]] || die "lab-api.service is unexpectedly active"

info "broken state confirmed"
