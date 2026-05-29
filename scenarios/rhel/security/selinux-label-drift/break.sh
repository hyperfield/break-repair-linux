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

SITE_ROOT="/srv/labsite"
SITE_FILE="/srv/labsite/index.html"

info "applying scenario: $SCENARIO_ID"

require_cmd getenforce
require_cmd semanage
require_cmd restorecon
require_cmd chcon

[[ "$(getenforce)" != "Disabled" ]] || die "SELinux is disabled on this system"

"$SCRIPT_DIR/reset.sh" --force >/dev/null 2>&1 || true

mkdir -p "$SITE_ROOT"
printf '%s\n' "lab site" > "$SITE_FILE"
semanage fcontext -d '/srv/labsite(/.*)?' >/dev/null 2>&1 || true
semanage fcontext -a -t httpd_sys_content_t '/srv/labsite(/.*)?' >/dev/null
restorecon -Rv "$SITE_ROOT" >/dev/null
chcon -R -t var_t "$SITE_ROOT"

ls -Zd "$SITE_FILE" | grep -Fq "var_t" || die "failed to apply the wrong SELinux label"
info "SELinux labels now drift from the persistent policy"
