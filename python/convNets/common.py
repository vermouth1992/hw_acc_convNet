""" This file defines common functions and path for CNN models"""

data_set_root = "/Users/chizhang/documents/matlab/usc/fpga2017/data_sets/"

def getCategory(index):
    synset_path = "./"
    f = open(synset_path + "synset_words.txt", "r")
    for i, line in enumerate(f):
        if i == index:
            return line