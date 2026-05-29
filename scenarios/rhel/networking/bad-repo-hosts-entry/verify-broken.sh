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

info "verifying broken state: $SCENARIO_ID"

grep -Eq "^192\.0\.2\.99[[:space:]]+$HOST_NAME([[:space:]]|$)" /etc/hosts || die "wrong hosts entry is missing"
[[ "$(getent hosts "$HOST_NAME" | awk 'NR == 1 {print $1}')" == "192.0.2.99" ]] || die "name resolution is not using the wrong address"

info "broken state confirmed"
