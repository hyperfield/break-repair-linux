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

IMAGE_FILE="/var/tmp/fstab-loopback-uuid-mismatch.img"
MOUNT_POINT="/mnt/labfstab"
BAD_UUID="00000000-1111-2222-3333-444444444444"
FSTAB_TAG="# break-repair-linux: fstab-loopback-uuid-mismatch"

info "verifying broken state: $SCENARIO_ID"

loopdev="$(losetup -j "$IMAGE_FILE" | cut -d: -f1 | head -n1)"
[[ -n "$loopdev" ]] || die "loop device for the lab image is missing"

grep -Fq "$FSTAB_TAG" /etc/fstab || die "tagged fstab entry is missing"
grep -Fq "UUID=$BAD_UUID" /etc/fstab || die "broken UUID is missing from /etc/fstab"
findmnt "$MOUNT_POINT" >/dev/null 2>&1 && die "$MOUNT_POINT should not be mounted"

info "broken state confirmed"
