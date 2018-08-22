#!/usr/bin/python

import sys, getopt
import os
import re

v=sys.version

if "2.7" in v:
    from Tkinter import *
elif "3.3" in v or "3.4" in v:
    from tkinter import *

version             = 0.2
verbose             = False

def files(path):
    for file in os.listdir(path):
        if os.path.isfile(os.path.join(path, file)):
            yield file

def verbose_print(str):
    global verbose
    if verbose:
        print str

def print_usage():
    print 'Add GPS info Version: ' + str(version)
    print 'Extract GPS info from a photo and apply to others'
    print ''
    print 'Usage: add_gps.py -i <input_filename> -o <output_filename> [-r <last_filename>]'
    print '\t-h, --help     print this message'
    print '\t-V, --version  print version information'
    print '\t-v, --verbose  print verbose messages'
    print '\t-i, --input    filename to extract GPS info from'
    print '\t-o, --output   output filename to add GPS info to'
    print '\t-r, --range    if using a range of output file, add the last filename'
    print ''

def print_version():
    print 'Add GPS info Version: ' + str(version)
    print 'Extract GPS info from a photo and apply to others'
    print ''
    print 'Changelist:'
    print '\tv0.2'
    print '\t - Add argument validation'
    print '\t - Add changelist'
    print ''
    print '\tv0.1'
    print '\t - Initial version'
    print '\t - Take an input file, extract GPS info and add it to'
    print '\t   output file(s) range'
    print ''

def check_arg(arg):
    if arg.startswith('-'):
        print 'ERROR: Incorrect argument: ' + arg + '\n'
        print_usage()
        sys.exit(2)

def parse_args(argv):
    global verbose
    filename = ''
    filterfile = ''
    try:
        opts, args = getopt.getopt(argv, "hVvi:f:", ["--help", "--version", "--verbose",
            "--input=", "--filter="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print_usage()
            sys.exit()
        elif opt in ("-V", "--version"):
            print_version()
            sys.exit()
        elif opt in ("-v", "--verbose"):
            verbose = True
        elif opt in ("-i", "--input"):
            check_arg(arg)
            filename = arg
        elif opt in ("-f", "--filter"):
            check_arg(arg)
            filterfile = arg

    # Check the input file
    if not filename:
        print_usage()
        sys.exit(2)
    elif not (os.path.exists(filename)):
        print 'Error: Could not find the input file: ' + filename
        sys.exit(2)

    return filename, filterfile
# End of parse_args

class App:
    def __init__(self, master):
        frame = Frame(master, bg="black")
        frame.pack()

        self.scrollbar = Scrollbar(frame)
        self.textbox = Text(frame, height=50, width=200, bg="black",
                fg="white", padx=5, pady=5)

        self.scrollbar.pack(side=RIGHT, fill=Y)
        self.textbox.pack(side=LEFT, fill=Y)

        self.scrollbar.config(command=self.textbox.yview)
        self.textbox.config(yscrollcommand=self.scrollbar.set)

    def add_text(self, text):
        self.textbox.insert(END, text)

    def init_filter(self, filename):
        with open(filename, "r") as file:
            self.filter = []
            for line in file:
                line = line.strip()
                p, bg, fg = line.split(',')
                self.filter.append(p)
                self.textbox.tag_config(p, background=bg, foreground=fg)

    def apply_filter(self):
        for pattern in self.filter:
            count = IntVar()
            index = "1.0"
            while True:
                index = self.textbox.search(pattern, index,
                        stopindex=END, count=count)
                if index == "": break
                if count.get() == 0: break
                start = index
                end = self.textbox.index("%s + %s c" % (index, count.get()))
                self.textbox.tag_add(pattern, start, end)
                index = end
# End of class App

if __name__ == "__main__":
    logFilename, filterFilename = parse_args(sys.argv[1:])

    root = Tk()
    app = App(root)

    if (os.path.exists(filterFilename)):
        app.init_filter(filterFilename)

    with open(logFilename, "r") as file:
        for line in file:
            app.add_text(line)

    app.apply_filter()

    root.mainloop()
    #root.destroy()
