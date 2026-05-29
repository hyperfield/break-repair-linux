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

info "cleaning up task: $TASK_ID"

sed -i '\|/mnt/lvlogs|d' /etc/fstab
umount /mnt/lvlogs >/dev/null 2>&1 || true

if lvs labvg/lvlogs >/dev/null 2>&1; then
  lvremove -fy /dev/labvg/lvlogs >/dev/null 2>&1 || true
fi

if vgs labvg >/dev/null 2>&1; then
  pv_names="$(pvs --noheadings -o pv_name --select vg_name=labvg | xargs)"
  vgremove -fy labvg >/dev/null 2>&1 || true
  for pv_name in $pv_names; do
    pvremove -fy "$pv_name" >/dev/null 2>&1 || true
  done
fi

for loopdev in $(losetup -j "$IMAGE_FILE" | cut -d: -f1); do
  losetup -d "$loopdev" >/dev/null 2>&1 || true
done

rm -f "$IMAGE_FILE"
rmdir /mnt/lvlogs >/dev/null 2>&1 || true

info "task cleanup complete"
