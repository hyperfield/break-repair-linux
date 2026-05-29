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

systemctl cat lab-api.service >/dev/null 2>&1 || die "lab-api.service does not exist"
systemctl cat lab-api.service | grep -Eq '^ExecStart=/usr/local/bin/lab-api.sh$' || die "ExecStart is not corrected"
[[ "$(systemctl is-enabled lab-api.service)" == "enabled" ]] || die "lab-api.service is not enabled"
[[ "$(systemctl is-active lab-api.service)" == "active" ]] || die "lab-api.service is not active"

for _ in 1 2 3; do
  [[ -f /var/tmp/lab-api.heartbeat ]] && break
  sleep 2
done

[[ -f /var/tmp/lab-api.heartbeat ]] || die "heartbeat file was not created"
info "repaired state confirmed"
