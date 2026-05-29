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

SITE_FILE="/srv/labsite/index.html"

info "verifying broken state: $SCENARIO_ID"

require_cmd getenforce
require_cmd matchpathcon

[[ "$(getenforce)" != "Disabled" ]] || die "SELinux is disabled on this system"
[[ -f "$SITE_FILE" ]] || die "site file is missing"
matchpathcon "$SITE_FILE" | grep -Fq "httpd_sys_content_t" || die "persistent file-context mapping is missing"
ls -Zd "$SITE_FILE" | grep -Fq "httpd_sys_content_t" && die "actual label already matches the persistent context"

info "broken state confirmed"
