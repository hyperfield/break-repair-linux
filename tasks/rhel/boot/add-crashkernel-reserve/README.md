# Add Crashkernel Reserve

This lab reuses the same persistent kernel-argument skill, but with a parameter
used for crash capture workflows.

## Prerequisites

- Use a disposable RH-compatible VM snapshot and run the lab as root.
- Be comfortable inspecting and changing saved kernel command-line arguments.
- Know that `crashkernel=` reserves memory for a crash capture kernel used by
  `kdump`. You do not need to know full `kdump` setup for this lab.
- Expect verification to check the saved default boot entry rather than the
  currently running kernel state.
