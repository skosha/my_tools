#!/usr/bin/env python

import sys
import re
import xlrd
from collections import OrderedDict

# Constants
country_idx = 5             # Column index containing the country code, the channel information starts right after this
outFile = 'new_db.txt'      # output file name

# 2.4G
start_idx = 4               # First row with country data
last_ch_idx = 19            # Column index of the last channel information

# 5G
start_idx_5g = 5            # First row with country data
last_ch_idx_5g = 33         # Column index of the last channel information

# Initialize the dictionary
db_dict = dict()

# Channel center frequencies
channel_freq = [2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484, 0, 5180, 5200, 5220, 5240, 0, 5260, 5280, 5300, 5320, 0, 5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640, 5660, 5680, 5700, 5720, 0, 5745, 5765, 5785, 5805, 5825]

# Parse the arguments
numOfArgs = len(sys.argv)
if numOfArgs != 2:
    print("Provide the excel filename\n")
    sys.exit(1)
srcFile = sys.argv[1]

# Open the workbook
xl_wb = xlrd.open_workbook(srcFile, on_demand = True)

# Work on sheet 1 - 2.4G
xl_sheet = xl_wb.sheet_by_index(1)

for row_idx in range(start_idx - 1, xl_sheet.nrows - 1):     # Iterate through all the rows
    country_code = xl_sheet.cell_value(row_idx, country_idx)
    db_dict[country_code] = []
    for col_idx in range(country_idx + 1, last_ch_idx + 1):     # Iterate through all channels
        db_dict[country_code].append(xl_sheet.cell_value(row_idx, col_idx))
    db_dict[country_code].append(' ')

# Close first sheet
xl_wb.unload_sheet(1)

# Work on sheet 2 - 5G
xl_sheet = xl_wb.sheet_by_index(2)

for row_idx in range(start_idx_5g - 1, xl_sheet.nrows - 1):     # Iterate through all the rows
    country_code = xl_sheet.cell_value(row_idx, country_idx)
    for col_idx in range(country_idx + 1, last_ch_idx_5g + 1):     # Iterate through all channels
        db_dict[country_code].append(xl_sheet.cell_value(row_idx, col_idx))

# Close second sheet
xl_wb.unload_sheet(2)

# Create a sorted dictionary
o_db_dict = OrderedDict(sorted(db_dict.items()))

# Release resources
xl_wb.release_resources()
del db_dict
del xl_wb

# Parse through the dictionary for each country and add it to the output file
with open(outFile, "w") as oFile:
    for country, chns in o_db_dict.iteritems():
        oString = 'Country ' + country + ':\n'
        low_freq = 0
        high_freq = 0
        for i in range(0, len(channel_freq)):
            if chns[i] == 'Yes':
                # If an adjacent channel already exists, add to the freq range
                low_freq = low_freq if low_freq != 0 else (channel_freq[i] - 10)
                high_freq = channel_freq[i] + 10
            else:
                # Print the previous freq range and reset the frequencies
                if low_freq != 0: oString += '\t(' + str(low_freq) + ' - ' + str(high_freq) + ')\n'
                low_freq = 0
                high_freq = 0
        if low_freq != 0: oString += '\t(' + str(low_freq) + ' - ' + str(high_freq) + ')\n'
        oString += '\n'
        # Write to the out file
        oFile.write(oString)
