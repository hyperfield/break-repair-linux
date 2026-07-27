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
require_cmd firewall-cmd

info "verifying broken state: $SCENARIO_ID"

firewall-cmd --state >/dev/null 2>&1 || die "firewalld is not running"
firewall-cmd --query-port=8080/tcp >/dev/null 2>&1 && die "8080/tcp is allowed in runtime config"
firewall-cmd --permanent --query-port=8080/tcp >/dev/null 2>&1 && \
  die "8080/tcp is allowed in permanent config"

info "broken state confirmed"
