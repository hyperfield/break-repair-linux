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

require_root
require_os_family "$SCENARIO_FAMILY"
require_force_arg "${1:-}"

SCRIPT_PATH="/usr/local/bin/lab-api.sh"
UNIT_PATH="/etc/systemd/system/lab-api.service"

info "resetting scenario: $SCENARIO_ID"

systemctl disable --now lab-api.service >/dev/null 2>&1 || true
rm -f "$UNIT_PATH"
rm -f "$SCRIPT_PATH"
rm -f /var/tmp/lab-api.heartbeat
systemctl daemon-reload

info "scenario reset complete"
