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

require_cmd nmcli

nmcli connection show lab-static >/dev/null 2>&1 || die "connection lab-static does not exist"
[[ "$(nmcli -g connection.type connection show lab-static)" == "dummy" ]] || die "connection type is not dummy"
[[ "$(nmcli -g connection.interface-name connection show lab-static)" == "dummy0" ]] || die "interface name is not dummy0"
[[ "$(nmcli -g ipv4.method connection show lab-static)" == "manual" ]] || die "IPv4 method is not manual"
[[ "$(nmcli -g ipv4.addresses connection show lab-static)" == "198.51.100.20/24" ]] || die "IPv4 address is incorrect"
[[ "$(nmcli -g ipv4.gateway connection show lab-static)" == "198.51.100.1" ]] || die "IPv4 gateway is incorrect"
[[ "$(nmcli -g ipv4.dns connection show lab-static)" == "198.51.100.53" ]] || die "IPv4 DNS is incorrect"
[[ "$(nmcli -g ipv6.method connection show lab-static)" == "disabled" ]] || die "IPv6 method is not disabled"
[[ "$(nmcli -g connection.autoconnect connection show lab-static)" == "yes" ]] || die "autoconnect is not enabled"
nmcli -t -f NAME connection show --active | grep -Fxq "lab-static" || die "connection is not active"

info "task verified successfully"
