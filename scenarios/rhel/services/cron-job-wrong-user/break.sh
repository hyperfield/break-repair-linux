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

SCRIPT_PATH="/usr/local/bin/lab-cron-report.sh"
CRON_FILE="/etc/cron.d/lab-cron-report"

info "applying scenario: $SCENARIO_ID"

cat > "$SCRIPT_PATH" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
date '+%F %T lab cron report' > /var/tmp/lab-cron-report.stamp
EOF
chmod 0755 "$SCRIPT_PATH"

cat > "$CRON_FILE" <<'EOF'
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
*/5 * * * * labmissing /usr/local/bin/lab-cron-report.sh
EOF
chmod 0644 "$CRON_FILE"

info "cron job now references a missing user"
