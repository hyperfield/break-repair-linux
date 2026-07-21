# Missing Serial Console Kernel Arg

- The system may still boot normally on a VGA or graphical console.
- The symptom is missing kernel and login output on the serial console.
- Inspect the saved default boot entry rather than the live kernel command line.
- RH systems have a dedicated tool for persistent kernel boot arguments.
