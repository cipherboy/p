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

## Philosophy

`p` is concise in that common operations are given one-letter command aliases;
e.g., `p g <file> [<key>]` fetches the given JSON key (if specified, otherwise,
defaults to `password`) from the specified file.

`p` is opionated in that it prefers metadata to be stored as JSON, while
remaining compatible with the defacto standard of first line being the target
password. Also, `p` insists that there's one right command to perform an
action, unlike pass where the following are equivalent:

    - `pass <file>`
    - `pass ls <file>`
    - `pass show <file>`

Under `p`, the `ls` operation only lists files and directories and will not
show the contents of the file.
