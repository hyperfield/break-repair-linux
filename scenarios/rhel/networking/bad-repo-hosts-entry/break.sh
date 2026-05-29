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

HOST_NAME="repo-rhel-lab.example.test"
HOST_TAG="# break-repair-linux: bad-repo-hosts-entry"

info "applying scenario: $SCENARIO_ID"

sed -i "\|$HOST_NAME|d" /etc/hosts
printf '192.0.2.99 %s %s\n' "$HOST_NAME" "$HOST_TAG" >> /etc/hosts

info "/etc/hosts now maps $HOST_NAME to the wrong address"
