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

info "applying scenario: $SCENARIO_ID"

require_cmd nmcli

nmcli connection delete lab-broken >/dev/null 2>&1 || true
ip link delete dummy1 >/dev/null 2>&1 || true

nmcli connection add type dummy ifname dummy1 con-name lab-broken \
  ipv4.method manual ipv4.addresses 198.51.100.130/24 \
  ipv4.gateway 198.51.100.254 ipv4.dns 203.0.113.53 ipv6.method ignore >/dev/null
nmcli connection modify lab-broken connection.autoconnect yes >/dev/null
nmcli connection up lab-broken >/dev/null 2>&1 || true

info "dummy profile now has the wrong IPv4 settings"
