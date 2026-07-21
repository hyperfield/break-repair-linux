# Task Format

Tasks are for build/configure/verify exercises rather than break/repair drills.

Every task should live in:

```text
tasks/<family>/<category>/<slug>/
```

## Required Files

- `metadata.env`
- `prompt.md`
- `verify.sh`
- `hints.md`
- `solution.md`

## Optional Files

- `prepare.sh`
- `cleanup.sh`
- task-specific helper data such as source files, sample configs, or fixtures

## `metadata.env`

The template uses simple shell variables so the repo utilities can source them:

```bash
TASK_ID="static-ip-with-dns"
TASK_TITLE="Static IP with DNS"
TASK_FAMILY="rhel"
TASK_CATEGORY="networking"
DIFFICULTY="medium"
REQUIRES_ROOT="yes"
SNAPSHOT_RECOMMENDED="yes"
```

## Script Semantics

- `prepare.sh` should build the starting state when the task needs one.
- `verify.sh` should exit `0` only when the requested end state is correct.
- `cleanup.sh` should remove task artifacts when implemented.

## Authoring Guidelines

- Write the task statement so the learner knows the target state, not the steps.
- Include exact values the learner could not reasonably infer from the starting
  state.
- Keep verification deterministic and machine-checkable.
- Use `--force` for prep or cleanup steps that change the host materially.
- Prefer one clear objective per task.
- Keep hints short and solution-focused rather than exam-style trickery.
- Do not hide required target values only in `solution.md` or `verify.sh`.
