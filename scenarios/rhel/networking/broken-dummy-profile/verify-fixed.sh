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

require_cmd nmcli

nmcli connection show lab-broken >/dev/null 2>&1 || die "connection lab-broken does not exist"
[[ "$(nmcli -g connection.interface-name connection show lab-broken)" == "dummy1" ]] || die "interface name is incorrect"
[[ "$(nmcli -g ipv4.method connection show lab-broken)" == "manual" ]] || die "IPv4 method is incorrect"
[[ "$(nmcli -g ipv4.addresses connection show lab-broken)" == "198.51.100.30/24" ]] || die "IPv4 address is incorrect"
[[ "$(nmcli -g ipv4.gateway connection show lab-broken)" == "198.51.100.1" ]] || die "IPv4 gateway is incorrect"
[[ "$(nmcli -g ipv4.dns connection show lab-broken)" == "198.51.100.53" ]] || die "IPv4 DNS is incorrect"
[[ "$(nmcli -g ipv6.method connection show lab-broken)" == "disabled" ]] || die "IPv6 method is incorrect"
nmcli -t -f NAME connection show --active | grep -Fxq "lab-broken" || die "connection is not active"

info "repaired state confirmed"
