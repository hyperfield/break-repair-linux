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

IMAGE_FILE="/var/tmp/boot-wait-bad-labfstab-entry.img"
MOUNT_POINT="/mnt/bootrepair"

info "verifying repaired state: $SCENARIO_ID"

loopdev="$(losetup -j "$IMAGE_FILE" | cut -d: -f1 | head -n1)"
[[ -n "$loopdev" ]] || die "loop device for the lab image is missing"

real_uuid="$(blkid -s UUID -o value "$loopdev")"
entry_count="$(awk '$2 == "/mnt/bootrepair" {count++} END {print count + 0}' /etc/fstab)"
[[ "$entry_count" -eq 1 ]] || die "expected exactly one repaired /etc/fstab entry for /mnt/bootrepair"
entry="$(awk '$2 == "/mnt/bootrepair" {print $1 "|" $3 "|" $4}' /etc/fstab)"

fstab_source="${entry%%|*}"
rest="${entry#*|}"
fstab_type="${rest%%|*}"
fstab_opts="${rest##*|}"

[[ "$fstab_source" == "UUID=$real_uuid" ]] || die "/etc/fstab does not use the correct UUID"
[[ "$fstab_type" == "xfs" ]] || die "/etc/fstab type for /mnt/bootrepair is not xfs"
printf '%s\n' "$fstab_opts" | grep -Eq '(^|,)nofail($|,)' || die "/etc/fstab is missing nofail"
printf '%s\n' "$fstab_opts" | grep -Eq '(^|,)x-systemd\.device-timeout=1s($|,)' || \
  die "/etc/fstab is missing x-systemd.device-timeout=1s"
findmnt "$MOUNT_POINT" >/dev/null 2>&1 || die "/mnt/bootrepair is not mounted"

info "repaired state confirmed"
