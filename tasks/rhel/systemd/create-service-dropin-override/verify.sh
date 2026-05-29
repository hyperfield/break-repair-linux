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

require_os_family "$TASK_FAMILY"

info "verifying task result: $TASK_ID"

systemctl cat lab-sleeper.service >/dev/null 2>&1 || die "lab-sleeper.service does not exist"
[[ -d /etc/systemd/system/lab-sleeper.service.d ]] || die "drop-in directory is missing"
find /etc/systemd/system/lab-sleeper.service.d -maxdepth 1 -type f -name '*.conf' | grep -q . || \
  die "no drop-in override was found for lab-sleeper.service"
[[ "$(systemctl show -p Restart --value lab-sleeper.service)" == "on-failure" ]] || die "Restart policy is not on-failure"
systemctl cat lab-sleeper.service | grep -Eq '^RestartSec=30s$' || die "RestartSec is not 30s"
[[ "$(systemctl is-enabled lab-sleeper.service)" == "enabled" ]] || die "service is not enabled"
[[ "$(systemctl is-active lab-sleeper.service)" == "active" ]] || die "service is not active"

info "task verified successfully"
