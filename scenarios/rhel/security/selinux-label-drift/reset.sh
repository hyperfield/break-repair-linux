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

SITE_ROOT="/srv/labsite"

info "resetting scenario: $SCENARIO_ID"

if command -v semanage >/dev/null 2>&1; then
  semanage fcontext -d '/srv/labsite(/.*)?' >/dev/null 2>&1 || true
fi

if command -v restorecon >/dev/null 2>&1; then
  restorecon -Rv "$SITE_ROOT" >/dev/null 2>&1 || true
fi

rm -rf "$SITE_ROOT"
info "scenario reset complete"
