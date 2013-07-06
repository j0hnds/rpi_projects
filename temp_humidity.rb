#!/usr/bin/env ruby

# This script reads from the serial port to catch 
# the output of the Arduino that is reading from the
# DHT11 temp/humidity sensor. Totally cool.

require 'serialport'
require 'sqlite3'

# Set up the database connection. Creates the Readings table
# if it doesn't already exist.
def db_setup
  path_to_db = File.join(File.dirname(__FILE__), "temp_humidity.db")
  SQLite3::Database.open(path_to_db).tap do | db |
    db.execute "CREATE TABLE IF NOT EXISTS Readings(ReadAt TEXT PRIMARY KEY, humidity REAL, temperature REAL)"
  end
end

SERIAL_PORT = '/dev/ttyACM0'
BAUD_RATE = 9600

# We can read from the serial port way faster than we care
# to save the data for. So we will read this many readings
# from the serial port before we insert a reading into the
# database. Just thins the data out a bit.
#
READINGS_PER_SAVE = 1000

db = db_setup

ser = SerialPort.new(SERIAL_PORT)

ser.read_timeout = 10000

reading_count = 0

begin

  # Each record is an ascii line separated by a carriage-return
  # newline. Easy-peasy. This loop will terminate when we run out
  # stuff on the serial port which will be NEVER. That's why we
  # can run this thing as a daemon because the loop never ends.
  #
  while ((value = ser.readline "\r\n") != nil) do
    values = value.split(",")

    # This next is a safety check. If the number of values in
    # the values list is not exactly 2, then we assume corrupted
    # data and skip the reading. This can happen at startup, so
    # better safe than sorry. Given that we taking only 1/10000 of
    # the data anyway, we're not missing much.
    next if values.size != 2

    (humidity, temperature) = values
    db.execute "INSERT INTO Readings VALUES(datetime('now'), #{humidity}, #{temperature})" if reading_count == 0
    reading_count += 1
    reading_count = 0 if reading_count == READINGS_PER_SAVE
  end
ensure
  ser.close
  db.close if db
end

