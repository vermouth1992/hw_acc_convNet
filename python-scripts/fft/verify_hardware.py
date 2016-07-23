import os
import sys
from util.ucb import main

@main
def main():
    assert sys.argv[1] == "-i" and sys.argv[3] == "-o"
    input_file = sys.argv[2]
    output_file = sys.argv[4]
