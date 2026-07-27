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

IMAGE_FILE="/var/tmp/boot-safe-labfstab-mount.img"
MOUNT_POINT="/mnt/bootlab"

info "preparing task: $TASK_ID"

"$SCRIPT_DIR/cleanup.sh" --force >/dev/null 2>&1 || true

truncate -s 384M "$IMAGE_FILE"
loopdev="$(losetup -f --show "$IMAGE_FILE")"
wipefs -a "$loopdev" >/dev/null 2>&1 || true
mkfs.xfs -f "$loopdev" >/dev/null
mkdir -p "$MOUNT_POINT"

info "created loopback filesystem on $loopdev for /mnt/bootlab"
