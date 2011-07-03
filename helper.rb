require 'mongo'
require 'bson'
require 'yaml'
require 'json'
require 'kconv'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
  exit 1
end

begin
  @@mongo = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port'])
  @@db = @@mongo.db(@@conf['mongo_dbname'])
rescue => e
  STDERR.puts 'MongoDB connection error!'
  STDERR.puts e
  exit 1
end


