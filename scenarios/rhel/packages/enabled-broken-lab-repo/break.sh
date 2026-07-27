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

REPO_FILE="/etc/yum.repos.d/lab-broken.repo"

info "applying scenario: $SCENARIO_ID"

mkdir -p /etc/yum.repos.d

cat > "$REPO_FILE" <<'EOF'
[lab-broken]
name=Broken Lab Repository
baseurl=http://repo-rhel-lab.example.test/missing/BaseOS/
enabled=1
gpgcheck=0
EOF

info "lab-broken repository is enabled with an unavailable baseurl"
