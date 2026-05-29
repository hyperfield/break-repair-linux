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

"$SCRIPT_DIR/cleanup.sh" --force >/dev/null 2>&1 || true

mkdir -p /srv/labsite
printf '%s\n' "lab site content" > /srv/labsite/index.html

if command -v restorecon >/dev/null 2>&1; then
  restorecon -Rv /srv/labsite >/dev/null 2>&1 || true
fi

info "created /srv/labsite with default labels"
