#!/usr/bin/python

import os
import sys

def add_setting(root, file):
    file_extension = os.path.splitext(file)[1]
    filename = root + file
    if file_extension == ".v":
        tag = "VERILOG_FILE"
    elif file_extension == ".sv":
        tag = "SYSTEMVERILOG_FILE"
    else:
        tag = None

    if tag != None:
        return "set_global_assignment -name " + tag + \
            " $MY_WORKDIR/" + filename + "\n"

if __name__ == "__main__":
    # traverse root directory, and list directories as dirs and files as files
    settings = ""
    folder = sys.argv[1]
    for root, dirs, files in os.walk(folder):
        # print root, dirs, files
        for file in files:
            s = add_setting(root, file)
            if s != None:
                settings += s
    print settings
