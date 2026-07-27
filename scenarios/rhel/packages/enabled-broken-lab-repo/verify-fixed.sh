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

REPO_FILE="/etc/yum.repos.d/lab-broken.repo"

info "verifying repaired state: $SCENARIO_ID"

[[ -f "$REPO_FILE" ]] || die "lab-broken repo file is missing"
grep -Fxq "[lab-broken]" "$REPO_FILE" || die "repo id is missing"
grep -Fxq "enabled=0" "$REPO_FILE" || die "lab-broken repo is still enabled"
grep -Fxq "gpgcheck=0" "$REPO_FILE" || die "gpgcheck setting is missing"

info "repaired state confirmed"
