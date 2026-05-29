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

STATE_DIR="$(exercise_state_dir "$TASK_ID")"

info "preparing task: $TASK_ID"

ensure_exercise_state_dir "$TASK_ID"

if kernel_arg_present_default "$BOOT_CRASHKERNEL_ARG"; then
  printf 'yes\n' > "$STATE_DIR/original-crashkernel-arg-present"
else
  printf 'no\n' > "$STATE_DIR/original-crashkernel-arg-present"
fi

remove_kernel_arg_all "$BOOT_CRASHKERNEL_ARG" >/dev/null 2>&1 || true
info "crashkernel kernel argument removed for the exercise"
