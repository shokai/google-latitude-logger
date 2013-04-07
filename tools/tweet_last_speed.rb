#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require File.expand_path '../helper', File.dirname(__FILE__)
require 'args_parser'

parser = ArgsParser.parse ARGV do
  arg :min, 'calc recent N minutes', :alias => :m, :default => 10
  arg :tweet_cmd, 'path to tweet command', :alias => :t, :default => 'tw --pipe'
  arg :help, 'show help', :alias => :h
end

if parser.has_option? :help
  puts parser.help
  exit
end

R = 6378137

def distance(a, b)
  d_lon = (a.geo_lon - b.geo_lon).abs*(Math::PI/180) # 経度
  d_lat = (a.geo_lat - b.geo_lat).abs*(Math::PI/180) # 緯度
  d_y = R * d_lon * Math.cos(a.geo_lat*(Math::PI/180))
  d_x = R * d_lat
  Math.sqrt(d_x*d_x + d_y*d_y)
end

def speed(a, b)
  a_b = distance(a, b)
  a_b/(a.time_stamp-b.time_stamp)*60*60/1000 # km/h
end

def direction(a, b)
  dx = (a.geo_lon-b.geo_lon).abs
  dy = (a.geo_lat-b.geo_lat).abs
  if dx*0.7 > dy
    if a.geo_lon > b.geo_lon
      return '東'
    else
      return '西'
    end
  elsif dx*1.3 < dy
    if a.geo_lat > b.geo_lat
      return '北'
    else
      return '南'
    end
  else
    if a.geo_lon > b.geo_lon
      if a.geo_lat > b.geo_lat
        return '北東'
      else
        return '北西'
      end
    else
      if a.geo_lat > b.geo_lat
        return '南東'
      else
        return '南西'
      end
    end
  end
end

locs = Location.where(:time_stamp.gt => Time.now.to_i-60*parser[:min].to_i).desc(:time_stamp)

case locs.count
when 0
  puts "no locations found recent #{parser[:min].to_i} mins"
  exit
when 1
  locs = Location.desc(:time_stamp).limit(2)
end

a = locs.first
b = locs.last

[a,b].each{|i|
  puts "#{Time.at(i.time_stamp)} #{i.reverse_geocode} (#{i.geo_lat},#{i.geo_lon})"
}
puts "and more #{locs.count-2} locations" if locs.count > 2

sp = speed(a, b).to_i
dir = direction(a, b)
trans = '徒歩'
if sp > 100
  trans = '飛行機か新幹線とか'
elsif sp > 30
  trans = '車か電車'
elsif sp > 5
  trans = 'バスか自転車'
end

puts cmd = "echo '時速#{sp}Kmで#{dir}にたぶん#{trans}で移動中' | #{parser[:tweet_cmd]}"
if sp < 2
  puts 'not tweet'
  exit
end
system cmd
