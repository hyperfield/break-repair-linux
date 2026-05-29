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

IMAGE_FILE="/var/tmp/fstab-loopback-uuid-mismatch.img"
MOUNT_POINT="/mnt/labfstab"
BAD_UUID="00000000-1111-2222-3333-444444444444"
FSTAB_TAG="# break-repair-linux: fstab-loopback-uuid-mismatch"

info "applying scenario: $SCENARIO_ID"

require_cmd losetup
require_cmd mkfs.xfs
require_cmd blkid

"$SCRIPT_DIR/reset.sh" --force >/dev/null 2>&1 || true

truncate -s 512M "$IMAGE_FILE"
loopdev="$(losetup -f --show "$IMAGE_FILE")"
wipefs -a "$loopdev" >/dev/null 2>&1 || true
mkfs.xfs -f "$loopdev" >/dev/null
mkdir -p "$MOUNT_POINT"

printf 'UUID=%s %s xfs defaults,nofail,x-systemd.device-timeout=1s 0 0 %s\n' \
  "$BAD_UUID" "$MOUNT_POINT" "$FSTAB_TAG" >> /etc/fstab

findmnt "$MOUNT_POINT" >/dev/null 2>&1 && umount "$MOUNT_POINT" >/dev/null 2>&1 || true

info "fstab entry now uses an invalid UUID"
