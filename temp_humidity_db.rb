class TempHumidityDb

  def initialize
    @client = Mongo::MongoClient.new('localhost', 27017)
  end

  def db
    @db ||= @client['arduino']
  end

  def collection
    @coll ||= db['temp_humidity']
  end

  def close
    @client.close if @client
  end
end

