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

STATE_DIR="$(exercise_state_dir "$SCENARIO_ID")"

info "applying scenario: $SCENARIO_ID"

ensure_exercise_state_dir "$SCENARIO_ID"

if kernel_arg_present_default "$BOOT_SERIAL_ARG"; then
  printf 'yes\n' > "$STATE_DIR/original-serial-arg-present"
else
  printf 'no\n' > "$STATE_DIR/original-serial-arg-present"
fi

remove_kernel_arg_all "$BOOT_SERIAL_ARG" >/dev/null 2>&1 || true
info "serial console kernel argument is now missing"
info "normal VGA or graphical boots may still look healthy; this fault affects serial-console access"
