#!/usr/bin/env python

import sys, getopt
import os
import fnmatch
import re

version             = 0.1
prefix              = ''
start_count         = 0
verbose             = False

# Constants
jpg_path            = 'jpg/'
cr2_path            = 'raw/'
mobile_path         = 'mobile/'

def files(path):
    for file in os.listdir(path):
        if os.path.isfile(os.path.join(path, file)):
            yield file

def verbose_print(str):
    global verbose
    if verbose:
        print str

def print_usage():
    print 'Sort Pics Version: ' + str(version)
    print '\n'
    print 'Usage: sort_pics.py -p <prefix> -n <start_number>'
    print '\t-h, --help     print this help'
    print '\t-p             prefix to be added to all filenames'
    print '\t-n, --num      starting count of the filenames'
    print '\n'


def parse_args(argv):
    global prefix
    global start_count
    global verbose
    try:
        opts, args = getopt.getopt(argv, "hvp:n:", ["--help", "--num="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print_usage()
            sys.exit()
        elif opt == "-v":
            verbose = True
        elif opt == "-p":
            prefix = arg
        elif opt in ("-n", "--num"):
            start_count = int(arg)
    if not prefix:
        print_usage()
        sys.exit(2)


parse_args(sys.argv[1:])

cwd = os.getcwd()

# Create the jpg/ and raw/ path
if not os.path.exists(jpg_path):
    verbose_print('Creating ' + jpg_path)
    os.makedirs(jpg_path)

if not os.path.exists(cr2_path):
    verbose_print('Creating ' + cr2_path)
    os.makedirs(cr2_path)

if not os.path.exists(mobile_path):
    verbose_print('Creating ' + mobile_path)
    os.makedirs(mobile_path)

# Find all the JPG files, sorted in time order
pattern = re.compile(r'.*\.(jpg|JPG)')
files = [file for file in os.listdir(".") if (pattern.search(file) is not None)]
files.sort(key=os.path.getctime)

# Rename and move the jpg files to jpg/ and corresponding raw file to raw/
count = start_count if start_count > 0 else 0
for file in files:
    filename, extension = os.path.splitext(file)
    if filename.startswith('IMG'):
        new_filename = jpg_path + prefix + '_' + str(count).zfill(3) + '.jpg'
    else:
        new_filename = mobile_path + prefix + '_' + str(count).zfill(3) + '.jpg'
    verbose_print('Rename ' + file + ' to ' + new_filename)
    os.rename(file, new_filename)
    if (os.path.exists(filename + '.CR2')):
        new_filename = cr2_path + prefix + '_' + str(count).zfill(3) + '.CR2'
        verbose_print('Rename ' + filename + '.CR2 to ' + new_filename)
        os.rename(filename + '.CR2', new_filename)
    count += 1

# Delete unmatched CR2 files
raw_pattern = re.compile(r'IMG_[0-9]{4}.CR2')
files_to_del = [file for file in os.listdir(".") if (raw_pattern.search(file) is not None)]
for file in files_to_del:
    verbose_print('Deleting ' + file)
    os.remove(file)
