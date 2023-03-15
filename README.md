# SpaceInfo

A simple command line utility that returns MacOS spaces & display info.

I use this with Keyboard Maestro to manipulate windows across multiple spaces and displays.


## Options

```
--active-display
--total-displays
--active-space
--first-space
--last-space
--total-spaces

-d <d>             Restrict total spaces info to a specific display number
-v                 Verbose output
--version          Show the version.
-h, --help         Show help information.

```

The functionality for pulling the relevant info is adapted from [WhichSpace](https://github.com/gechr/WhichSpace)

## Installation

- download and unzip
- place in a directory in your path

As this binary is not signed you'll want to first open it in Finder and then answer the scary "are you sure" question in the affirmative. Gatekeeper should then permit it to run subsequently.

