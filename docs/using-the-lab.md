# Using The Lab

This repository is meant to be used on disposable Linux systems, typically a
VM that you can roll back quickly.

The scripts in this repo intentionally change system configuration. Some of
them create broken boot settings, modify `fstab`, change kernel arguments,
rebuild initramfs images, adjust SELinux labeling, or create and remove users,
units, mounts, and loop devices.

## Recommended Environment

The safest setup is:

1. one Rocky Linux or other RH-compatible VM dedicated to this lab
2. a clean baseline install with the tools you want to practice
3. one snapshot taken before you start using the repo
4. no important personal data inside the VM

Good targets include:

- Rocky Linux
- RHEL
- AlmaLinux
- Oracle Linux
- CentOS Stream

## Prerequisites

Before you start, make sure the VM has:

- a shell with standard admin tools available
- `sudo` access or direct root access
- enough free disk space for loopback images and initramfs rebuilds
- NetworkManager if you want to run the networking exercises
- SELinux enabled if you want to run the SELinux exercises
- LVM and XFS tooling if you want to run the storage exercises

Some exercises also assume these tools exist:

- `grubby`
- `dracut`
- `lsinitrd`
- `nmcli`
- `semanage`
- `lvm` commands such as `pvcreate`, `vgcreate`, `lvcreate`
- `mkfs.xfs`

If a script depends on a command that is missing, it should fail early.

## Safety Rules

- Treat every exercise as destructive until proven otherwise.
- Prefer a VM snapshot restore over trying to reuse a dirty system.
- Read the exercise directory contents before you run it.
- Run only one exercise at a time on a given VM snapshot.
- Use root only inside the lab VM, not on your workstation or a shared host.

## Snapshot Strategy

Recommended snapshot workflow:

1. build or boot a clean VM
2. create a snapshot named something like `lab-clean`
3. run exactly one exercise
4. repair or complete it manually
5. verify the result
6. restore `lab-clean`
7. start the next exercise

This is the most reliable workflow, especially for boot and storage exercises.

## Two Exercise Types

There are two exercise models in this repo.

### Break / Repair Scenarios

These are under:

```text
scenarios/<family>/<category>/<slug>/
```

They deliberately put the system into a broken state. Typical files:

- `break.sh`
- `verify-broken.sh`
- `verify-fixed.sh`
- `reset.sh`
- `hints.md`
- `solution.md`

Typical workflow:

1. start from a clean snapshot
2. run `break.sh`
3. confirm the system is actually broken with `verify-broken.sh`
4. repair the system manually
5. confirm the repair with `verify-fixed.sh`
6. restore the snapshot or run `reset.sh`

### Setup / Verification Tasks

These are under:

```text
tasks/<family>/<category>/<slug>/
```

They ask you to build a correct final state. Typical files:

- `prompt.md`
- `prepare.sh`
- `verify.sh`
- `cleanup.sh`
- `hints.md`
- `solution.md`

Typical workflow:

1. start from a clean snapshot
2. read `prompt.md`
3. run `prepare.sh` if the task provides starting-state setup
4. complete the task manually
5. run `verify.sh`
6. restore the snapshot or run `cleanup.sh`

## Fastest Way To Use The Repo

For most practice sessions, the selector scripts are the easiest entry point.

### Launch an Exercise

```bash
./scripts/select-exercise
```

Useful variations:

```bash
./scripts/select-exercise --random --scenarios
./scripts/select-exercise --tasks --category boot
./scripts/select-exercise --id sshd-invalid-dropin
```

`select-exercise` will show the matching exercise and then ask you to type
`BREAK` before it runs the associated `break.sh` or `prepare.sh --force`.

### Verify an Exercise

```bash
./scripts/verify-exercise
```

Useful variations:

```bash
./scripts/verify-exercise --id sshd-invalid-dropin
./scripts/verify-exercise --id sshd-invalid-dropin --state broken
./scripts/verify-exercise --random --tasks --category boot
```

For scenarios:

- default verification is `verify-fixed.sh`
- `--state broken` runs `verify-broken.sh`

For tasks:

- verification runs `verify.sh`

## Manual Workflow

If you want to inspect everything yourself instead of using the selectors:

### Scenario Example

```bash
cd scenarios/rhel/services/sshd-invalid-dropin
sudo ./break.sh --force
./verify-broken.sh
# repair manually
./verify-fixed.sh
sudo ./reset.sh --force
```

### Task Example

```bash
cd tasks/rhel/boot/set-default-multi-user-target
cat prompt.md
sudo ./prepare.sh --force
# complete the task manually
./verify.sh
sudo ./cleanup.sh --force
```

## When To Use Snapshot Restore Versus Reset / Cleanup

Use snapshot restore when:

- the exercise touches boot configuration
- the system may no longer be trustworthy
- you want a guaranteed clean next run
- you are moving to a different exercise

Use `reset.sh` or `cleanup.sh` when:

- you want to repeat the same exercise quickly
- the script clearly implements a clean reversal
- you understand what the script created or modified

If there is any doubt, restore the snapshot.

## Suggested Practice Routine

A productive RHCSA-style routine looks like this:

1. pick one category for a session, such as `boot`, `storage`, or `identity`
2. run 3-5 exercises from that category
3. do the repair or setup without reading `solution.md`
4. use `hints.md` only after you get stuck
5. verify the result with the matching verify script
6. restore the snapshot and repeat
7. later, repeat the same exercises under time pressure

## Troubleshooting The Lab Itself

If an exercise script fails before applying the intended state:

1. read the error message
2. inspect the exercise directory
3. check whether required commands are installed
4. confirm you are on the expected distro family
5. confirm you are root if the script requires root
6. restore the snapshot if the system is now in an unknown state

## Final Advice

Do not try to build a huge pile of overlapping breakages on the same VM state.
That teaches cleanup improvisation more than systematic troubleshooting.

One clean state, one exercise, one verification, then reset or restore.
