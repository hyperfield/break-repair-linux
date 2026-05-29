#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../../../.." && pwd)"

# shellcheck disable=SC1091
source "$REPO_ROOT/lib/common.sh"
# shellcheck disable=SC1091
source "$REPO_ROOT/lib/platform.sh"
# shellcheck disable=SC1091
source "$REPO_ROOT/lib/boot.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/metadata.env"

require_root
require_os_family "$SCENARIO_FAMILY"
require_force_arg "${1:-}"

SUPPORT_FILE="/etc/dracut.conf.d/90-break-repair-loop.conf"
BAD_FILE="/etc/dracut.conf.d/91-break-repair-omit-loop.conf"

info "resetting scenario: $SCENARIO_ID"

rm -f "$SUPPORT_FILE" "$BAD_FILE"
dracut -f "$(current_initramfs_path)" "$(uname -r)" >/dev/null

info "scenario reset complete"
