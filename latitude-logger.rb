#!/usr/bin/env ruby
require 'rubygems'
require 'open-uri'
require 'json'
require 'mongo'
require 'yaml'
require 'kconv'

begin
  conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
  exit 1
end

begin
  mongo = Mongo::Connection.new(conf['mongo_server'], conf['mongo_port'])
  db = mongo.db(conf['mongo_dbname'])
rescue => e
  STDERR.puts 'MongoDB connection error!'
  STDERR.puts e
  exit 1
end

url = "http://www.google.com/latitude/apps/badge/api?user=#{conf['user_id']}&type=json"

begin
  p data = JSON.parse(open(url).read.toutf8)
rescue Timeout::Error  => e
  STDERR.puts e
  exit 1
rescue => e
  STDERR.puts e
  exit 1
end

bson_id = db['locations'].insert(data)
if bson_id
  puts "save! => #{bson_id}"
end
