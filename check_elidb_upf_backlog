#!/usr/bin/python

import re
import sys
import glob
import commands

### Set these ###################################
threshold = 100                                 #
upf_dir = '/app/tnstaf/cedfiles/elidb-lookup'   #
cfg_file = '/app/tnstaf/cfg/elidb-local.cfg'    #
log_file = '/app/tnstaf/logs/elidb-updated.log' #
#################################################

# Get current dist set name
dist_set_param = commands.getstatusoutput("grep elidb_dist_set " + cfg_file)
current_dist_set = dist_set_param[1].split('-')[1]

# Search UPF directory for files matching current dist set.  Then sort the list and extract the newest.
searchstring = upf_dir + "/*/*" + current_dist_set.strip() + "*.done"
filelist = glob.glob(searchstring)
ids = [i.split('-')[4] for i in filelist]
ids = [int(x) for x in ids]
ids.sort()
newest = ids[-1]

# Find last loaded UPF.
logfile = re.findall('.*successfully loaded.*', open(log_file, 'r').read())
last_loaded = logfile[-1].split('-')[7]

# Determine drift and set to 0 if result is a negative (can happen if the updated proc is faster than this script.
drift = int(newest) - int(last_loaded)
if drift < 0:
        drift = 0

# Evaluate drift and exit accordingly.
if drift > threshold:
        print "WARNING: ELIDB Updated is %s UPFs behind (threshold is %s)." % (drift,threshold)
        sys.exit(1)
else:
        print "OK: ELIDB Updated is %s UPFs behind (threshold is %s)." % (drift,threshold)
        sys.exit(0)
