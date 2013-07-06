#!/bin/bash

# First we need to dump the readings from the database into a file
# that has line numbers
./dump_readings.rb | nl > temp_humidity.dat

# Then we run gnuplot to create the chart
gnuplot temp_humidity.gp

# Done. Just that simple