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

info "verifying repaired state: $SCENARIO_ID"

loopdev="$(losetup -j "$IMAGE_FILE" | cut -d: -f1 | head -n1)"
[[ -n "$loopdev" ]] || die "loop device for the lab image is missing"

real_uuid="$(blkid -s UUID -o value "$loopdev")"
mapfile -t fstab_entries < <(awk '$2 == "/mnt/labfstab" {print $1 " " $3}' /etc/fstab)
[[ "${#fstab_entries[@]}" -eq 1 ]] || die "expected exactly one /mnt/labfstab entry in /etc/fstab"
[[ "${fstab_entries[0]}" == "UUID=$real_uuid xfs" ]] || die "/etc/fstab does not use the correct UUID and type"

findmnt "$MOUNT_POINT" >/dev/null 2>&1 || die "$MOUNT_POINT is not mounted"
info "repaired state confirmed"
