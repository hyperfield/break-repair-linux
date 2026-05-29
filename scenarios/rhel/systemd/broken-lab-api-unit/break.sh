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

SCRIPT_PATH="/usr/local/bin/lab-api.sh"
UNIT_PATH="/etc/systemd/system/lab-api.service"

info "applying scenario: $SCENARIO_ID"

"$SCRIPT_DIR/reset.sh" --force >/dev/null 2>&1 || true

cat > "$SCRIPT_PATH" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

while true; do
  date '+%F %T lab-api healthy' > /var/tmp/lab-api.heartbeat
  sleep 5
done
EOF
chmod 0755 "$SCRIPT_PATH"

cat > "$UNIT_PATH" <<'EOF'
[Unit]
Description=Break Repair Lab API

[Service]
Type=simple
ExecStart=/usr/local/bin/lab-api-broken.sh
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now lab-api.service >/dev/null 2>&1 || true
[[ "$(systemctl is-active lab-api.service)" != "active" ]] || die "service unexpectedly started successfully"

info "lab-api.service is now broken"
