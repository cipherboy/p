#!/usr/bin/python3

import os
import shutil

BASE_REPO = os.path.abspath(os.path.dirname(os.path.realpath(__file__)))

BIN_DIR = os.path.join(BASE_REPO, "bin")
EXECUTABLE = os.path.join(BIN_DIR, "p")

SOURCE_DIR = os.path.join(BASE_REPO, "src")
MAIN_SOURCE = os.path.join(SOURCE_DIR, "main.bash")

def main():
    # Recreate /bin/ if necessary
    if os.path.exists(BIN_DIR):
        shutil.rmtree(BIN_DIR)
    os.makedirs(BIN_DIR, exist_ok=False)

    # Build p executable. Whenever a
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
            for line in open(include_path, 'r').read().split("\n"):
                p_file.write(whitespace)
                p_file.write(line)
                p_file.write("\n")
        else:
            p_file.write(main_line)
            p_file.write("\n")

    p_file.close()


if __name__ == "__main__":
    main()
