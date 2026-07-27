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

DROP_DIR="/srv/labdrop"

info "applying scenario: $SCENARIO_ID"

rm -rf "$DROP_DIR"
mkdir -p "$DROP_DIR"
chown root:root "$DROP_DIR"
chmod 0777 "$DROP_DIR"
printf '%s\n' "shared lab dropbox" > "$DROP_DIR/README"

info "/srv/labdrop is world-writable without the sticky bit"
