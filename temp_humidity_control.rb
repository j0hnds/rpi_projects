#!/usr/bin/env ruby
require 'daemons'

# Use this script to run the temperature/humidity data capture in the
# background (and nohuped).
#
# To start:
#     temp_humidity_control.rb start
# To stop:
#     temp_humidity_control.rb stop

# Need the full path to the script to run in the background
path_to_script = File.join(File.dirname(__FILE__), "temp_humidity.rb")

# Run the script. The PID file will be in the same directory as the script.
Daemons.run path_to_script
