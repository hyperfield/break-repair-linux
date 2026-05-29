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
require_os_family "$TASK_FAMILY"

info "verifying task result: $TASK_ID"

require_cmd visudo

id labops >/dev/null 2>&1 || die "user labops does not exist"
[[ "$(id -gn labops)" == "labops" ]] || die "labops primary group is not labops"
id -nG labops | tr ' ' '\n' | grep -Fxq "wheel" || die "labops is not in wheel"
[[ "$(getent passwd labops | cut -d: -f7)" == "/bin/bash" ]] || die "labops shell is not /bin/bash"
[[ -d /home/labops ]] || die "home directory /home/labops does not exist"

shadow_entry="$(getent shadow labops)"
IFS=':' read -r _ _ _ shadow_min shadow_max shadow_warn _ shadow_expire _ <<<"$shadow_entry"
[[ "$shadow_min" == "1" ]] || die "password minimum age is not 1 day"
[[ "$shadow_max" == "90" ]] || die "password maximum age is not 90 days"
[[ "$shadow_warn" == "7" ]] || die "password warning period is not 7 days"
[[ -z "$shadow_expire" ]] || die "labops should not have a fixed account expiration date"

[[ -f /etc/sudoers.d/labops-restart-sshd ]] || die "sudoers drop-in is missing"
[[ "$(stat -c '%a' /etc/sudoers.d/labops-restart-sshd)" == "440" ]] || die "sudoers drop-in mode must be 0440"
grep -Fxq "labops ALL=(root) NOPASSWD: /usr/bin/systemctl restart sshd" /etc/sudoers.d/labops-restart-sshd || \
  die "sudoers rule is missing or incorrect"
visudo -cf /etc/sudoers >/dev/null 2>&1 || die "sudoers validation failed"

info "task verified successfully"
