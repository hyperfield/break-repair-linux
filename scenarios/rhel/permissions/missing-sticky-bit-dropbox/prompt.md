# Missing Sticky Bit Dropbox

Ticket: `/srv/labdrop` is a shared dropbox where any local user may create
files. Users should not be able to delete each other's files.

Target state:

- `/srv/labdrop` exists
- owner and group are `root:root`
- mode is `1777`
