#!/usr/bin/env python

import sys, getopt
import os
import fnmatch
import re

# Globals

class Helper:
    _version            = 0.2
    _verbose            = False

    def __init__(self): pass

    def parse_args(self, argv):
        prefix              = ''
        start_count         = 0
        try:
            opts, args = getopt.getopt(argv, "hVvp:n:", ["--help", "--version",
            "--verbose", "--prefix=", "--num="])
        except getopt.GetoptError:
            self._print_usage()
            sys.exit(2)
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                self._print_usage()
                sys.exit()
            elif opt in ("-V", "--version"):
                self._print_version()
                sys.exit()
            elif opt in ("-v", "--verbose"):
                self._verbose = True
            elif opt in ("-p", "--prefix"):
                self._check_arg(arg)
                prefix = arg
            elif opt in ("-n", "--num"):
                self.check_arg(arg)
                start_count = int(arg)
        if not prefix:
            self._print_usage()
            sys.exit(2)
        return prefix, start_count
    # End of parse args

    def files(self, path):
        for file in os.listdir(path):
            if os.path.isfile(os.path.join(path, file)):
                yield file

    def verbose_print(self, str):
        if self._verbose: print str

    def _check_arg(self, arg):
        if arg.startswith('-'):
            print 'ERROR: Incorrect argument: ' + arg + '\n'
            self._print_usage()
            sys.exit(2)

    def _print_usage(self):
        print 'Sort Pics Version: ' + str(self._version)
        print ''
        print 'Usage: sort_pics.py -p <prefix> [-n <start_number>]'
        print '\t-h, --help     print this help'
        print '\t-V, --version  print version information'
        print '\t-v, --verbose  print verbose messages'
        print '\t-p, --prefix   prefix to be added to all filenames'
        print '\t-n, --num      starting count of the filenames, default 0'
        print ''

    def _print_version(self):
        print 'Sort Pics Version: ' + str(self._version)
        print ''
        print ''
        print 'Changelist:'
        print '\tv0.2'
        print '\t - Add argument validation'
        print '\t - Add changelist'
        print '\t - Modularisation of the code'
        print ''
        print '\tv0.1'
        print '\t - Initial version'
        print '\t - Take a prefix and add it to all the image files'
        print '\t   and move them to jpg, raw and mobile folders.'
        print '\t - Take a starting number to begin the image count as'
        print ''

# End of class Helper

class PicSort:
    def __init__(self, dir, prefix):
        # Create the jpg/ and raw/ path
        self.dir            = dir
        self.prefix         = prefix
        self.jpg_path       = os.path.join(dir, 'jpg')
        self.raw_path       = os.path.join(dir, 'raw')
        self.mobile_path    = os.path.join(dir, 'mobile')

        if not os.path.exists(self.jpg_path):
            fn.verbose_print('Creating ' + self.jpg_path)
            os.makedirs(self.jpg_path)

        if not os.path.exists(self.raw_path):
            fn.verbose_print('Creating ' + self.raw_path)
            os.makedirs(self.raw_path)

        if not os.path.exists(self.mobile_path):
            fn.verbose_print('Creating ' + self.mobile_path)
            os.makedirs(self.mobile_path)
    # End of __init__

    def sort_files(self, start):
        # Find all the JPG files, sorted in time order
        pattern = re.compile(r'.*\.(jpg|JPG)')
        files = [file for file in os.listdir(self.dir) if (pattern.search(file) is not None)]
        files.sort(key=os.path.getctime)

        # Rename and move the jpg files to jpg/ and corresponding raw file to raw/
        count = start if start > 1 else 1
        for file in files:
            filename, extension = os.path.splitext(file)
            if filename.startswith('IMG'):
                new_filename = os.path.join(self.jpg_path, self.prefix + '_' + str(count).zfill(3) + '.jpg')
            else:
                new_filename = os.path.join(self.mobile_path, self.prefix + '_' + str(count).zfill(3) + '.jpg')
            fn.verbose_print('Rename ' + file + ' to ' + new_filename)
            os.rename(file, new_filename)
            if (os.path.exists(filename + '.CR2')):
                new_filename = os.path.join(self.raw_path, self.prefix + '_' + str(count).zfill(3) + '.CR2')
                fn.verbose_print('Rename ' + filename + '.CR2 to ' + new_filename)
                os.rename(filename + '.CR2', new_filename)
            count += 1
    # End of sort_files

    def cleanup(self):
        # Delete unmatched CR2 files
        raw_pattern = re.compile(r'IMG_[0-9]{4}.CR2')
        files_to_del = [file for file in os.listdir(self.dir) if (raw_pattern.search(file) is not None)]
        for file in files_to_del:
            fn.verbose_print('Deleting ' + file)
            os.remove(file)


if __name__ == "__main__":

    fn = Helper()
    prefix, start_count = fn.parse_args(sys.argv[1:])

    pics = PicSort(".", prefix)

    pics.sort_files(start_count)
    pics.cleanup()
