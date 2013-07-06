#!/usr/bin/env ruby

# Use this script to dump the readings from the SQLite database
# to stdout

require 'sqlite3'
require 'time'

READAT_COL = 0
HUMIDITY_COL = 1
TEMPERATURE_COL = 2

# Set up the database connection. Creates the Readings table
# if it doesn't already exist.
def db_setup
  path_to_db = File.join(File.dirname(__FILE__), "temp_humidity.db")
  SQLite3::Database.open(path_to_db).tap do | db |
    # Do anything here before we begin
  end
end

def c_to_f(centigrade)
  (centigrade * (9.0/5.0)) + 32.0
end

begin
  db = db_setup
  
  stmt = db.prepare "SELECT * FROM Readings ORDER BY ReadAt ASC"

  rs = stmt.execute

  rs.each do | row |
    dt = Time.parse("#{row[READAT_COL]} -0000").localtime
    humidity = row[HUMIDITY_COL]
    temperatureC = row[TEMPERATURE_COL]

    puts "#{dt}  #{humidity}% #{temperatureC}C (#{c_to_f(temperatureC.to_f)}F)"
  end
  
ensure
  stmt.close if stmt
  db.close if db
end
