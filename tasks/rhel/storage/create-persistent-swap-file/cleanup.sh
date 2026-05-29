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
require_os_family "$TASK_FAMILY"
require_force_arg "${1:-}"

info "cleaning up task: $TASK_ID"

swapoff /swap.lab >/dev/null 2>&1 || true
sed -i '\|^/swap\.lab[[:space:]]\+none[[:space:]]\+swap[[:space:]]|d' /etc/fstab
rm -f /swap.lab

info "task cleanup complete"
