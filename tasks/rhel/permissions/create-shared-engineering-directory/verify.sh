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

require_cmd getfacl

getent group labeng >/dev/null 2>&1 || die "group labeng does not exist"
[[ -d /srv/labshare ]] || die "/srv/labshare does not exist"
[[ "$(stat -c '%U:%G' /srv/labshare)" == "root:labeng" ]] || die "/srv/labshare owner or group is incorrect"
[[ "$(stat -c '%a' /srv/labshare)" == "2770" ]] || die "/srv/labshare mode must be 2770"

acl_output="$(getfacl -cp /srv/labshare)"
printf '%s\n' "$acl_output" | grep -Fxq "group::rwx" || die "group permissions are not rwx"
printf '%s\n' "$acl_output" | grep -Fxq "default:group::rwx" || die "default group permissions are not rwx"
printf '%s\n' "$acl_output" | grep -Fxq "default:group:labeng:rwx" || die "default ACL for labeng is missing"

info "task verified successfully"
