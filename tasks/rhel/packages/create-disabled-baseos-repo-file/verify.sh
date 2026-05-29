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

repo_file="/etc/yum.repos.d/lab-baseos.repo"

[[ -f "$repo_file" ]] || die "repo file is missing"
grep -Fxq "[lab-baseos]" "$repo_file" || die "repo id [lab-baseos] is missing"
grep -Fxq "name=Lab BaseOS" "$repo_file" || die "repo name is incorrect"
grep -Fxq "baseurl=http://repo.lab.example.com/rhel/9/BaseOS/x86_64/os/" "$repo_file" || die "baseurl is incorrect"
grep -Fxq "enabled=0" "$repo_file" || die "enabled must be 0"
grep -Fxq "gpgcheck=0" "$repo_file" || die "gpgcheck must be 0"

info "task verified successfully"
