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

SCRIPT_PATH="/usr/local/bin/lab-cache-clean.sh"
SERVICE_PATH="/etc/systemd/system/lab-cache-clean.service"
TIMER_PATH="/etc/systemd/system/lab-cache-clean.timer"

info "applying scenario: $SCENARIO_ID"

"$SCRIPT_DIR/reset.sh" --force >/dev/null 2>&1 || true

cat > "$SCRIPT_PATH" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
date '+%F %T cache cleaned' > /var/tmp/lab-cache-clean.stamp
EOF
chmod 0755 "$SCRIPT_PATH"

cat > "$SERVICE_PATH" <<'EOF'
[Unit]
Description=Break Repair Lab Cache Clean

[Service]
Type=oneshot
ExecStart=/usr/local/bin/lab-cache-clean.sh
EOF

cat > "$TIMER_PATH" <<'EOF'
[Unit]
Description=Break Repair Lab Cache Clean Timer

[Timer]
OnBootSec=2min
OnUnitActiveSec=15min
Unit=lab-cache-clean.service

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now lab-cache-clean.timer >/dev/null
systemctl mask --now lab-cache-clean.timer >/dev/null

[[ "$(systemctl is-enabled lab-cache-clean.timer)" == "masked" ]] || die "timer is not masked"
info "timer has been masked"
