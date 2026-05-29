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

[[ -x /usr/local/bin/lab-healthcheck.sh ]] || die "healthcheck script is missing or not executable"
systemctl cat lab-healthcheck.service >/dev/null 2>&1 || die "lab-healthcheck.service does not exist"
[[ "$(systemctl show -p Type --value lab-healthcheck.service)" == "oneshot" ]] || die "service type is not oneshot"
[[ "$(systemctl show -p RemainAfterExit --value lab-healthcheck.service)" == "yes" ]] || die "RemainAfterExit is not enabled"
systemctl cat lab-healthcheck.service | grep -Eq '^ExecStart=/usr/local/bin/lab-healthcheck.sh$' || \
  die "ExecStart does not point to /usr/local/bin/lab-healthcheck.sh"
[[ "$(systemctl is-enabled lab-healthcheck.service)" == "enabled" ]] || die "service is not enabled"
[[ "$(systemctl is-active lab-healthcheck.service)" == "active" ]] || die "service is not active"
[[ -f /var/tmp/lab-healthcheck.ok ]] || die "healthcheck output file is missing"
grep -Fq "ok" /var/tmp/lab-healthcheck.ok || die "healthcheck output file does not contain ok"

info "task verified successfully"
