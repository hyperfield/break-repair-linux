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

HOST_NAME="repo-rhel-lab.example.test"

info "verifying repaired state: $SCENARIO_ID"

entry_count="$(awk '$2 == "repo-rhel-lab.example.test" {count++} END {print count + 0}' /etc/hosts)"
[[ "$entry_count" -eq 1 ]] || die "expected exactly one hosts entry for $HOST_NAME"
grep -Eq "^192\.0\.2\.50[[:space:]]+$HOST_NAME([[:space:]]|$)" /etc/hosts || die "correct hosts entry is missing"
[[ "$(getent hosts "$HOST_NAME" | awk 'NR == 1 {print $1}')" == "192.0.2.50" ]] || die "name resolution is still incorrect"

info "repaired state confirmed"
