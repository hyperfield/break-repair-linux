#!/usr/bin/env bash

set -euo pipefail

info() {
  printf '[INFO] %s\n' "$*"
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

die() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

require_root() {
  [[ "${EUID:-$(id -u)}" -eq 0 ]] || die "this script must be run as root"
}

require_force_arg() {
  [[ "${1:-}" == "--force" ]] || die "refusing to continue without --force"
}

exercise_state_root() {
  printf '/var/lib/break-repair-linux\n'
}

exercise_state_dir() {
  local exercise_id
  exercise_id="$1"
  printf '%s/%s\n' "$(exercise_state_root)" "$exercise_id"
}

ensure_exercise_state_dir() {
  mkdir -p "$(exercise_state_dir "$1")"
}

clear_exercise_state_dir() {
  rm -rf "$(exercise_state_dir "$1")"
}
