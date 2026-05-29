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

require_cmd getenforce
require_cmd matchpathcon

[[ "$(getenforce)" != "Disabled" ]] || die "SELinux is disabled on this system"
[[ -f /srv/labsite/index.html ]] || die "/srv/labsite/index.html does not exist"

matchpathcon /srv/labsite/index.html | grep -Fq "httpd_sys_content_t" || die "default SELinux context is not persistent"
ls -Zd /srv/labsite/index.html | grep -Fq "httpd_sys_content_t" || die "actual SELinux label is not httpd_sys_content_t"

info "task verified successfully"
