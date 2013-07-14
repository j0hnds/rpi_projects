#!/usr/bin/env ruby

# Use this script to dump the readings from the SQLite database
# to stdout
$: << File.dirname(__FILE__)

require 'mongo'
require 'time'
require 'temp_humidity_db'

READAT_COL = 0
HUMIDITY_COL = 1
TEMPERATURE_COL = 2

# Set up the database connection. Creates the Readings table
# if it doesn't already exist.
def db_setup
  TempHumidityDb.new
end

def c_to_f(centigrade)
  (centigrade * (9.0/5.0)) + 32.0
end

begin
  db = db_setup

  db.collection.find(nil, :sort => [[ 'ReadAt', Mongo::ASCENDING ]]).each do | doc |
    dt = doc['ReadAt'].localtime
    humidity = doc['humidity']
    temperatureC = doc['temperature']
    puts "#{dt}  #{humidity}% #{temperatureC}C (#{c_to_f(temperatureC.to_f)}F)"
  end
ensure
  db.close if db
end
