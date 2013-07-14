#!/usr/bin/env ruby

# Invoke this script to remove readings older than 30 days from the
# mongo database

$: << File.dirname(__FILE__)

require 'mongo'
require 'temp_humidity_db'

THIRTY_DAYS = 60*60*24*30

begin
  db = TempHumidityDb.new

  db.collection.remove({:ReadAt => { '$lt' => (Time.now.utc - THIRTY_DAYS) }})
ensure
  db.close if db
end

