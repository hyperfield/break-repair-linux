# Missing Sticky Bit Dropbox

1. Inspect `/srv/labdrop` with `stat` or `ls -ld`.
2. Restore ownership to `root:root`.
3. Set the directory mode to `1777`.
4. Confirm the sticky bit appears in the mode.
