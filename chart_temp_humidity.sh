#!/bin/bash

EXE_DIR=$(dirname $0)

# First we need to dump the readings from the database into a file
# that has line numbers
${EXE_DIR}/dump_readings_mongo.rb | nl > /tmp/temp_humidity.dat

# Then we run gnuplot to create the chart
gnuplot ${EXE_DIR}/temp_humidity.gp

# Done. Just that simple