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

require_os_family "$TASK_FAMILY"

IMAGE_FILE="/var/tmp/boot-safe-labfstab-mount.img"
MOUNT_POINT="/mnt/bootlab"

info "verifying task result: $TASK_ID"

loopdev="$(losetup -j "$IMAGE_FILE" | cut -d: -f1 | head -n1)"
[[ -n "$loopdev" ]] || die "loop device for the lab image is missing"

real_uuid="$(blkid -s UUID -o value "$loopdev")"
entry_count="$(awk '$2 == "/mnt/bootlab" {count++} END {print count + 0}' /etc/fstab)"
[[ "$entry_count" -eq 1 ]] || die "expected exactly one /etc/fstab entry for /mnt/bootlab"
entry="$(awk '$2 == "/mnt/bootlab" {print $1 "|" $3 "|" $4}' /etc/fstab)"

fstab_source="${entry%%|*}"
rest="${entry#*|}"
fstab_type="${rest%%|*}"
fstab_opts="${rest##*|}"

[[ "$fstab_source" == "UUID=$real_uuid" ]] || die "/etc/fstab does not use the correct UUID"
[[ "$fstab_type" == "xfs" ]] || die "/etc/fstab type for /mnt/bootlab is not xfs"
printf '%s\n' "$fstab_opts" | grep -Eq '(^|,)defaults($|,)' || die "/etc/fstab is missing defaults"
printf '%s\n' "$fstab_opts" | grep -Eq '(^|,)nofail($|,)' || die "/etc/fstab is missing nofail"
printf '%s\n' "$fstab_opts" | grep -Eq '(^|,)x-systemd\.device-timeout=1s($|,)' || \
  die "/etc/fstab is missing x-systemd.device-timeout=1s"
findmnt "$MOUNT_POINT" >/dev/null 2>&1 || die "/mnt/bootlab is not mounted"

info "task verified successfully"
