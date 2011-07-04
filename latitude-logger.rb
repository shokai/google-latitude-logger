#!/usr/bin/env ruby
require 'rubygems'
require File.dirname(__FILE__)+'/helper'
require 'open-uri'
require 'pp'
require 'activesupport'

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


feature = data['features'][0]
props = feature['properties']

location = {
  :geo_lat => feature['geometry']['coordinates'][1],
  :geo_lon => feature['geometry']['coordinates'][0],
  :user_id => props['id']
}
props.each{|k,v|
  location[k.underscore.to_sym] = v
}

time = location[:time_stamp]
if @@db['locations'].find({:time_stamp => time}).count > 0
  puts "timeStamp #{time} already stored.."
  exit
end

bson_id = @@db['locations'].insert(location)
if bson_id
  puts "timeStamp #{time} save! => #{bson_id}"
end
