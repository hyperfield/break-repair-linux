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
require_cmd firewall-cmd

info "applying scenario: $SCENARIO_ID"

firewall-cmd --state >/dev/null 2>&1 || die "firewalld is not running"

firewall-cmd --remove-port=8080/tcp >/dev/null 2>&1 || true
firewall-cmd --permanent --remove-port=8080/tcp >/dev/null 2>&1 || true
firewall-cmd --reload >/dev/null

info "firewalld no longer allows 8080/tcp"
