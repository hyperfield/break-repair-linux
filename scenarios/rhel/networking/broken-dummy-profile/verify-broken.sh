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

require_cmd nmcli

nmcli connection show lab-broken >/dev/null 2>&1 || die "connection lab-broken does not exist"
[[ "$(nmcli -g ipv4.addresses connection show lab-broken)" == "198.51.100.130/24" ]] || die "broken address is missing"
[[ "$(nmcli -g ipv4.gateway connection show lab-broken)" == "198.51.100.254" ]] || die "broken gateway is missing"
[[ "$(nmcli -g ipv4.dns connection show lab-broken)" == "203.0.113.53" ]] || die "broken DNS value is missing"

info "broken state confirmed"
