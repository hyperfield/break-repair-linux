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
default_target_name > "$STATE_DIR/original-default-target"
systemctl set-default rescue.target >/dev/null

info "default target is now rescue.target"
