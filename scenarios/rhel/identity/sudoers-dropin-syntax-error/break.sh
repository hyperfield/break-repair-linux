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

DROP_IN="/etc/sudoers.d/99-break-repair-syntax"

info "applying scenario: $SCENARIO_ID"

require_cmd visudo

rm -f "$DROP_IN"
cat > "$DROP_IN" <<'EOF'
# break-repair-linux: sudoers-dropin-syntax-error
labfix ALL=(ALL) NOPASSWD /usr/bin/passwd root
EOF
chmod 0440 "$DROP_IN"

visudo -cf /etc/sudoers >/dev/null 2>&1 && die "expected sudoers validation to fail"
info "sudoers configuration is now invalid"
