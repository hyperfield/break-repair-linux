# Break / Repair Linux Lab

This repository is for Linux admin practice in two formats:

- break/repair scenarios that deliberately damage a system
- setup/verification tasks that ask you to build or configure something correctly

The initial focus is RH-compatible systems such as Rocky Linux, RHEL,
AlmaLinux, Oracle Linux, and CentOS Stream. The structure leaves room for
Debian-family and other distributions later.

The intended workflow is simple:

1. Start from a clean VM snapshot.
2. Choose either a scenario or a task.
3. Apply the exercise's starting state with `break.sh` or `prepare.sh`.
4. Do the repair or the requested setup manually.
5. Use the verification script to confirm the result.
6. Revert to the snapshot or run cleanup if the exercise provides it.

## Start Here

This repo is designed for disposable VMs, not for a workstation or a shared
server. Many exercises deliberately alter boot settings, `fstab`, users,
systemd units, SELinux labels, and storage layout.

Before you run anything:

1. use a Rocky Linux or other RH-compatible VM dedicated to the lab
2. create a clean snapshot before your first exercise
3. assume you will need `sudo` or root for most break or prepare scripts
4. run one exercise at a time
5. prefer restoring a snapshot over trying to reuse a dirty system

The practical usage guide is here:

- [docs/using-the-lab.md](/home/inte/projects/break-repair-linux/docs/using-the-lab.md)

Short version:

- use `./scripts/select-exercise` to choose and launch an exercise
- type `BREAK` only after you are sure you want to apply the state change
- do the repair or setup manually
- use `./scripts/verify-exercise` to check your result
- restore the VM snapshot or run `reset.sh` / `cleanup.sh`

Recommended first commands:

```bash
./scripts/select-exercise --random --scenarios
./scripts/verify-exercise --random --tasks --category boot
```

## Layout

```text
.
├── docs/                   Authoring and roadmap notes
├── lib/                    Shared shell helpers
├── scripts/                Repo utilities
├── templates/
│   ├── scenario/           Starter files for new break/repair scenarios
│   └── task/               Starter files for new setup/verify tasks
├── scenarios/              Break/repair exercises
│   ├── rhel/               Current primary target
│   └── debian/             Reserved for future work
└── tasks/                  Setup/verification exercises
    ├── rhel/               Current primary target
    └── debian/             Reserved for future work
```

Break/repair exercises live at:

```text
scenarios/<family>/<category>/<slug>/
```

Setup/verification tasks live at:

```text
tasks/<family>/<category>/<slug>/
```

Examples:

```text
scenarios/rhel/services/sshd-bad-permissions/
tasks/rhel/networking/static-ip-with-dns/
```

## Exercise Contracts

Break/repair scenarios contain:

- `metadata.env`: basic metadata for tooling.
- `break.sh`: applies the fault. This should normally require `--force`.
- `verify-broken.sh`: exits `0` when the fault is present.
- `verify-fixed.sh`: exits `0` when the machine has been repaired.
- `reset.sh`: optional cleanup path when a snapshot revert is not convenient.
- `hints.md`: short nudges for practice mode.
- `solution.md`: the reference repair path.

Setup/verification tasks contain:

- `metadata.env`: basic metadata for tooling.
- `prompt.md`: the task statement shown to the learner.
- `prepare.sh`: optional starting-state setup, usually requiring `--force`.
- `verify.sh`: exits `0` only when the requested end state exists.
- `cleanup.sh`: optional cleanup path when a snapshot revert is not convenient.
- `hints.md`: short nudges for practice mode.
- `solution.md`: the reference implementation path.

Authoring notes live in:

- [docs/using-the-lab.md](/home/inte/projects/break-repair-linux/docs/using-the-lab.md)
- [docs/scenario-format.md](/home/inte/projects/break-repair-linux/docs/scenario-format.md)
- [docs/task-format.md](/home/inte/projects/break-repair-linux/docs/task-format.md)
- [docs/rhel-exercise-catalog.md](/home/inte/projects/break-repair-linux/docs/rhel-exercise-catalog.md)

## Helper Scripts

- `./scripts/new-scenario rhel services sshd-bad-permissions`
- `./scripts/new-task rhel networking static-ip-with-dns`
- `./scripts/list-scenarios`
- `./scripts/list-tasks`
- `./scripts/check-scenarios`
- `./scripts/check-tasks`
- `./scripts/select-exercise`
- `./scripts/verify-exercise`

Examples:

- `./scripts/select-exercise`
- `./scripts/select-exercise --random --scenarios`
- `./scripts/select-exercise --tasks --category boot`
- `./scripts/select-exercise --id sshd-invalid-dropin`
- `./scripts/verify-exercise --id sshd-invalid-dropin`
- `./scripts/verify-exercise --id sshd-invalid-dropin --state broken`

`select-exercise` always asks you to type `BREAK` before it runs the selected
exercise's `break.sh` or `prepare.sh` with `--force`.

`verify-exercise` runs the matching verification entrypoint for the chosen
exercise. For scenarios it defaults to `verify-fixed.sh`, and you can use
`--state broken` to run `verify-broken.sh` instead.

## Prerequisites

At minimum, expect to need:

- a disposable RH-compatible VM
- `sudo` or root access
- enough free disk space for loopback images and initramfs rebuilds

Some exercise groups also assume tools or subsystems such as:

- `grubby`, `dracut`, `lsinitrd`
- NetworkManager and `nmcli`
- SELinux and `semanage`
- LVM tools and `mkfs.xfs`

The full prerequisites and safety guidance are covered in
[docs/using-the-lab.md](/home/inte/projects/break-repair-linux/docs/using-the-lab.md).

## Principles

- Prefer faults that are realistic for admin work: systemd, storage, SELinux,
  permissions, networking, boot, packages, identity, and service access.
- Keep each scenario focused enough that the root cause is clear after repair.
- Default to VM-only assumptions. These scripts are supposed to be destructive.

## License

This repository is licensed under the MIT License. See
[LICENSE](/home/inte/projects/break-repair-linux/LICENSE).

Because this repo contains intentionally destructive system-modifying scripts,
also read [DISCLAIMER](/home/inte/projects/break-repair-linux/DISCLAIMER)
before running anything outside a disposable lab VM.
