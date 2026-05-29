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

info "verifying task result: $TASK_ID"

require_cmd lvs
require_cmd blkid
require_cmd findmnt

lvs labvg/lvlogs >/dev/null 2>&1 || die "logical volume labvg/lvlogs does not exist"

lv_size="$(lvs --noheadings -o lv_size --units m --nosuffix labvg/lvlogs | tr -d ' ')"
[[ "${lv_size%.*}" == "96" ]] || die "logical volume size is not 96 MiB"
[[ "$(blkid -o value -s TYPE /dev/labvg/lvlogs)" == "xfs" ]] || die "filesystem type is not XFS"

mount_source="$(findmnt -n -o SOURCE /mnt/lvlogs)"
[[ "$mount_source" == "/dev/mapper/labvg-lvlogs" || "$mount_source" == "/dev/labvg/lvlogs" ]] || \
  die "/mnt/lvlogs is not mounted from labvg/lvlogs"

grep -Eq '^[^#[:space:]]+[[:space:]]+/mnt/lvlogs[[:space:]]+xfs[[:space:]]' /etc/fstab || \
  die "/etc/fstab does not contain a persistent XFS mount for /mnt/lvlogs"

info "task verified successfully"
