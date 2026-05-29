# Scenario Format

Every exercise should live in:

```text
scenarios/<family>/<category>/<slug>/
```

## Required Files

- `metadata.env`
- `break.sh`
- `verify-broken.sh`
- `verify-fixed.sh`
- `hints.md`
- `solution.md`

## Optional Files

- `reset.sh`
- scenario-specific helper data such as sample configs, unit files, or fixtures

## `metadata.env`

The template uses simple shell variables so the repo utilities can source them:

```bash
SCENARIO_ID="sshd-bad-permissions"
SCENARIO_TITLE="SSHD bad permissions"
SCENARIO_FAMILY="rhel"
SCENARIO_CATEGORY="services"
RISK_LEVEL="medium"
REQUIRES_ROOT="yes"
SNAPSHOT_RECOMMENDED="yes"
```

## Script Semantics

- `break.sh` should exit `0` only after the fault is applied.
- `verify-broken.sh` should exit `0` only when the fault is present.
- `verify-fixed.sh` should exit `0` only when the system is healthy again.
- `reset.sh` should return the machine to a known-good state when implemented.

## Authoring Guidelines

- Require `--force` for destructive operations.
- Fail fast with clear error messages.
- Assert the expected distro family before changing anything.
- Prefer backing up files before modifying them.
- Keep one scenario focused on one main idea.
- Avoid hidden side effects unrelated to the learning objective.

## Categories

The current RHEL layout is grouped by broad admin domains:

- `boot`
- `containers`
- `identity`
- `networking`
- `packages`
- `permissions`
- `security`
- `services`
- `storage`
- `systemd`

Use the closest category now. If the taxonomy needs to evolve later, move the
scenario directory rather than changing its internal contract.

