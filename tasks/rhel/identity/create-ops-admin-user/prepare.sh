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

info "preparing task: $TASK_ID"

rm -f /etc/sudoers.d/labops-restart-sshd

if id labops >/dev/null 2>&1; then
  userdel -r labops >/dev/null 2>&1 || userdel labops >/dev/null 2>&1 || true
fi

if getent group labops >/dev/null 2>&1; then
  groupdel labops >/dev/null 2>&1 || true
fi

info "task state reset for labops"
