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
require_os_family "$TASK_FAMILY"
require_force_arg "${1:-}"

DRACUT_FILE="/etc/dracut.conf.d/90-lab-loop.conf"

info "preparing task: $TASK_ID"

rm -f "$DRACUT_FILE"
dracut -f "$(current_initramfs_path)" "$(uname -r)" >/dev/null

info "loop-driver dracut snippet removed and initramfs rebuilt"
