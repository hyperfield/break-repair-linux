# SELinux Label Drift

1. Inspect the expected label with `matchpathcon`.
2. Inspect the current label with `ls -Z`.
3. Apply the correct label back to the current files without removing the persistent mapping.
4. Re-check that the live label and the expected label now match.
