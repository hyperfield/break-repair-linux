# Set Default Multi-User Target

This lab teaches one of the simplest boot concepts: the difference between the
system's current state and the default target saved for the next boot.

## Prerequisites

- Use a disposable RH-compatible VM snapshot and run the lab as root.
- Know that a `systemd` target is a named boot state such as
  `multi-user.target`, `graphical.target`, or `rescue.target`.
- Know that changing the default target does not immediately change the running
  system; it changes what the system aims for on the next boot.
- You do not need to reboot to complete this lab. Verification inspects the
  saved default target.
