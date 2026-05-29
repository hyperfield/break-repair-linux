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

IMAGE_FILE="/var/tmp/boot-wait-bad-labfstab-entry.img"
MOUNT_POINT="/mnt/bootrepair"

info "resetting scenario: $SCENARIO_ID"

sed -i '\|/mnt/bootrepair|d' /etc/fstab
umount "$MOUNT_POINT" >/dev/null 2>&1 || true

for loopdev in $(losetup -j "$IMAGE_FILE" | cut -d: -f1); do
  losetup -d "$loopdev" >/dev/null 2>&1 || true
done

rm -f "$IMAGE_FILE"
rmdir "$MOUNT_POINT" >/dev/null 2>&1 || true

info "scenario reset complete"
