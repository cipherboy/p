# `p`

`p` is a concise, opinionated interface over pass


## Requirements

Building `p` requires `python` to be installed; either Python 2 or Python 3
will suffice.

Using `p` requires `pass` and `jq` to be installed, or at least, available on
the system. However, additional functionality is provided by:

    - `su` -- for local user changes
    - `ssh` -- for executing `p` on remote servers
    - `tree`, `sed`, `grep`, `cat` and other Unix utilities.


## Building

To build `p`, cd into the main directory, and run the build script.

    cd p/
    ./build.py

This will create a directory, `bin/` with the built `p` command:

    ls `bin/p`

This script can be relocated anywhere and used assuming the dependencies above
are on the target system.

(Why a build system? The script was getting a little long so I split it int
 separate files. I wanted to be able to copy a single script anywhere and
 use it immediately, so the build script converts `. <path>` style imports
 into a single file. If you don't want to build `p`, you can test it with
 `cd p/src` and running `bash main.bash <args>`.)


## Philosophy

`p` is concise in that common operations are given one-letter command aliases;
e.g., `p g <file> [<key>]` fetches the given JSON key (if specified, otherwise,
defaults to `password`) from the specified file.

`p` is opinionated in that it prefers metadata to be stored as JSON, while
remaining compatible with the de facto standard of first line being the target
password. Also, `p` insists that there's one right command to perform an
action, unlike pass where the following are equivalent:

    - `pass <file>`
    - `pass ls <file>`
    - `pass show <file>`

Under `p`, the `ls` operation only lists files and directories and will not
show the contents of the file.
