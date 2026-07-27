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

require_os_family "$SCENARIO_FAMILY"

DROP_DIR="/srv/labdrop"

info "verifying repaired state: $SCENARIO_ID"

[[ -d "$DROP_DIR" ]] || die "$DROP_DIR does not exist"
[[ "$(stat -c '%U:%G %a' "$DROP_DIR")" == "root:root 1777" ]] || \
  die "$DROP_DIR ownership or mode is incorrect"

info "repaired state confirmed"
