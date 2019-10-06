#!/usr/bin/python3

import os
import shutil
import sharg

BASE_REPO = os.path.abspath(os.path.dirname(os.path.realpath(__file__)))

BIN_DIR = os.path.join(BASE_REPO, "bin")
EXECUTABLE = os.path.join(BIN_DIR, "p")

SOURCE_DIR = os.path.join(BASE_REPO, "src")
MAIN_SOURCE = os.path.join(SOURCE_DIR, "main.bash")

ASSETS_DIR = os.path.join(BASE_REPO, "assets")
CLI_CONFIG = os.path.join(ASSETS_DIR, "cli.yml")
GENERATED_PARSER = os.path.join(SOURCE_DIR, "utils", "args.bash")

def main():
    # Recreate /bin/ if necessary.
    if os.path.exists(BIN_DIR):
        shutil.rmtree(BIN_DIR)
    os.makedirs(BIN_DIR)

    # Recreate the generated argument parser. This file is checked into the
    # repository.
    parsed_cli = sharg.parse_yaml(CLI_CONFIG)
    parsed_cli.format_bash(_file=open(GENERATED_PARSER, 'w'))

    # Build p executable.
    p_file = open(EXECUTABLE, 'w')
    os.chmod(EXECUTABLE, 0o755)

    main_source = open(MAIN_SOURCE, 'r').read().split("\n")

    for main_line in main_source:
        stripped_line = main_line.strip()
        begins_include = stripped_line.startswith(". ")
        if begins_include:
            include_index = main_line.index(". ")
            whitespace = main_line[0:include_index]

            include_path_raw = main_line[include_index+2:].strip()
            include_path = os.path.join(SOURCE_DIR, include_path_raw)

            eof_marker = None
            for line in open(include_path, 'r').read().split("\n"):
                if ' <<' in line and ' <<<' not in line:
                    marker_index = line.index(' <<')
                    if eof_marker != None:
                        msg = "Malformed input: expecting EOF marker "
                        msg += f"{eof_marker} but haven't seen one!"
                        raise Exception(msg)
                    eof_marker = line[marker_index + len(' <<'):].strip()

                if eof_marker is None:
                    p_file.write(whitespace)
                    p_file.write(line)
                    p_file.write("\n")
                elif eof_marker:
                    p_file.write(line)
                    p_file.write("\n")
                    if line == eof_marker:
                        eof_marker = None
        else:
            p_file.write(main_line)
            p_file.write("\n")

    p_file.close()


if __name__ == "__main__":
    main()
