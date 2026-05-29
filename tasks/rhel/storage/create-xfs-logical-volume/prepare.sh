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
require_force_arg "${1:-}"

IMAGE_FILE="/var/tmp/create-xfs-logical-volume.img"

info "preparing task: $TASK_ID"

require_cmd losetup
require_cmd pvcreate
require_cmd vgcreate
require_cmd wipefs

"$SCRIPT_DIR/cleanup.sh" --force >/dev/null 2>&1 || true

truncate -s 512M "$IMAGE_FILE"
loopdev="$(losetup -f --show "$IMAGE_FILE")"
wipefs -a "$loopdev" >/dev/null 2>&1 || true
pvcreate -fy "$loopdev" >/dev/null
vgcreate labvg "$loopdev" >/dev/null
mkdir -p /mnt/lvlogs

info "created volume group labvg on $loopdev"
