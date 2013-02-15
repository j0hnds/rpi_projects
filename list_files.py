#!/usr/bin/env python

import glob
import time

files = sorted(glob.glob("/home/pi/*.jpg"))

for file in files:
    # time.sleep(1)
    print file
