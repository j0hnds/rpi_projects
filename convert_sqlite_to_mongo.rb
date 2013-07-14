#!/usr/bin/env ruby

# This script will read the data form the SQLite data base
# and write it to the mongo database.

$: << File.dirname(__FILE__)

require 'mongo'
require 'sqlite3'
require 'time'
require 'temp_humidity_db'

READAT_COL = 0
HUMIDITY_COL = 1
TEMPERATURE_COL = 2

# Set up the database connection. Creates the Readings table
# if it doesn't already exist.
def db_setup
  path_to_db = "/tmp/temp_humidity.db"
  SQLite3::Database.open(path_to_db).tap do | db |
    # Do anything here before we begin
  end
end

begin

  db = db_setup
  mongodb = TempHumidityDb.new

  stmt = db.prepare "SELECT * FROM Readings ORDER BY ReadAt ASC"

  rs = stmt.execute

  rs.each do | row |
    puts "Read row..."
    dt = Time.parse("#{row[READAT_COL]} -0000").localtime
    humidity = row[HUMIDITY_COL]
    temperatureC = row[TEMPERATURE_COL]
    mongodb.collection.insert( { 'ReadAt' => dt, 
                                 'temperature' => temperatureC.to_f,
                                 'humidity' => humidity.to_f })
  end
  rs.close
ensure
  # stmt.close if stmt
  db.close if db
  mongodb.close if mongodb
end

