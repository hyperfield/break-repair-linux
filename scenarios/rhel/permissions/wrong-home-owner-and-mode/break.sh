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

LAB_USER="labanalyst"

info "applying scenario: $SCENARIO_ID"

id "$LAB_USER" >/dev/null 2>&1 || useradd -m -s /bin/bash "$LAB_USER"
chown "$LAB_USER:$LAB_USER" "/home/$LAB_USER"
chmod 0700 "/home/$LAB_USER"

chown root:root "/home/$LAB_USER"
chmod 0755 "/home/$LAB_USER"

info "home directory ownership and mode are now broken"
