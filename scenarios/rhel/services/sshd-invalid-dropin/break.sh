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

DROP_IN="/etc/ssh/sshd_config.d/99-break-repair-invalid.conf"

info "applying scenario: $SCENARIO_ID"

require_cmd sshd

rm -f "$DROP_IN"
cat > "$DROP_IN" <<'EOF'
# break-repair-linux: sshd-invalid-dropin
ThisDirectiveDoesNotExist yes
EOF
chmod 0600 "$DROP_IN"

sshd -t >/dev/null 2>&1 && die "expected sshd configuration test to fail"
info "sshd configuration is now invalid"
