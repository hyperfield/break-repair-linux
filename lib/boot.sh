#!/usr/bin/env bash

set -euo pipefail

BOOT_SERIAL_ARG="console=ttyS0,115200n8"
BOOT_CRASHKERNEL_ARG="crashkernel=256M"

current_initramfs_path() {
  printf '/boot/initramfs-%s.img\n' "$(uname -r)"
}

kernel_args_default() {
  require_cmd grubby
  grubby --info DEFAULT | sed -n 's/^args="\([^"]*\)"$/\1/p'
}

kernel_arg_present_default() {
  local arg
  arg="$1"
  kernel_args_default | tr ' ' '\n' | grep -Fxq "$arg"
}

add_kernel_arg_all() {
  local arg
  arg="$1"
  require_cmd grubby
  grubby --update-kernel=ALL --args="$arg" >/dev/null
}

remove_kernel_arg_all() {
  local arg
  arg="$1"
  require_cmd grubby
  grubby --update-kernel=ALL --remove-args="$arg" >/dev/null
}

initramfs_contains_pattern() {
  local pattern
  pattern="$1"
  require_cmd lsinitrd
  lsinitrd "$(current_initramfs_path)" | grep -Eq "$pattern"
}

default_target_name() {
  systemctl get-default
}
