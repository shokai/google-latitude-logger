#!/usr/bin/env ruby
require 'rubygems'
require File.dirname(__FILE__)+'/helper'
require 'open-uri'
require 'pp'

url = "http://www.google.com/latitude/apps/badge/api?user=#{@@conf['user_id']}&type=json"

begin
  pp data = JSON.parse(open(url).read.toutf8)
rescue Timeout::Error  => e
  STDERR.puts e
  exit 1
rescue => e
  STDERR.puts e
  exit 1
end

time = data['features'][0]['properties']['timeStamp']

if @@db['locations'].find({:features => {:$ne =>{:timeStamp => time}}}).count > 0
  puts 'timeStamp #{time} already stored..'
  exit
end

bson_id = @@db['locations'].insert(data)
if bson_id
  puts "timeStamp #{time} save! => #{bson_id}"
end
