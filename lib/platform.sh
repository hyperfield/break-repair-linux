#!/usr/bin/env bash

set -euo pipefail

load_os_release() {
  [[ -r /etc/os-release ]] || die "cannot read /etc/os-release"
  # shellcheck disable=SC1091
  source /etc/os-release
}

detect_os_family() {
  load_os_release

  case " ${ID:-} ${ID_LIKE:-} " in
    *" rhel "*|*" rocky "*|*" almalinux "*|*" centos "*|*" fedora "*|*" ol "*)
      printf 'rhel\n'
      ;;
    *" debian "*|*" ubuntu "*|*" linuxmint "*|*" pop "*)
      printf 'debian\n'
      ;;
    *" sles "*|*" opensuse "*)
      printf 'suse\n'
      ;;
    *)
      printf 'unknown\n'
      ;;
  esac
}

require_os_family() {
  local expected actual
  expected="$1"
  actual="$(detect_os_family)"
  [[ "$actual" == "$expected" ]] || die "scenario expects '$expected' but detected '$actual'"
}

