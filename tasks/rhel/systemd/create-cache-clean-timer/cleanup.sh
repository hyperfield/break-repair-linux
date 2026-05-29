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

systemctl disable --now lab-cache-clean.timer >/dev/null 2>&1 || true
systemctl disable --now lab-cache-clean.service >/dev/null 2>&1 || true
rm -f /etc/systemd/system/lab-cache-clean.timer
rm -f /etc/systemd/system/lab-cache-clean.service
rm -f /usr/local/bin/lab-cache-clean.sh
rm -f /var/tmp/lab-cache-clean.stamp
systemctl daemon-reload

info "task cleanup complete"
