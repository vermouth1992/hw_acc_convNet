import os
import sys

suffix = ["h", "cpp", "tab", "o", "v"]
apps = ["GCD"]

command = sys.argv[1]
if command == "-clean":
    for s in suffix:
        os.system("rm -rf *." + s)
    for app in apps:
        os.system("rm -rf " + app)
elif command == "-run":
    flag = sys.argv[2]
    if flag == "v":
        os.system("sbt 'run --backend v --genHarness'")
    elif flag == "c":
        os.system("sbt 'run --backend c --compile --test --genHarness'")
else:
    raise Error("Unknown flag")





