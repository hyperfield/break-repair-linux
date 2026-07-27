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

SCRIPT_PATH="/usr/local/bin/lab-cron-report.sh"
CRON_FILE="/etc/cron.d/lab-cron-report"

info "verifying repaired state: $SCENARIO_ID"

[[ -x "$SCRIPT_PATH" ]] || die "cron script is missing or not executable"
[[ -f "$CRON_FILE" ]] || die "cron file is missing"
grep -Eq '^\*/5[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+root[[:space:]]+/usr/local/bin/lab-cron-report\.sh$' \
  "$CRON_FILE" || die "cron job does not run as root with the expected schedule and command"

info "repaired state confirmed"
