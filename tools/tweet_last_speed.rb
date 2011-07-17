#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require File.dirname(__FILE__)+'/../helper'
require 'ArgsParser'

parser = ArgsParser.parser
parser.bind(:min, :m, 'calc recent N minutes', 10)
parser.bind(:tweet_cmd, :t, 'path to tweet command', '/usr/local/sbin/tweet_log')
parser.bind(:help, :h, 'show help')
first, params = parser.parse(ARGV)

if parser.has_option(:help)
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

locs = Location.where(:time_stamp.gt => Time.now.to_i-60*params[:min].to_i).desc(:time_stamp)

if locs.count < 2
  puts "no locations found recent #{params[:min].to_i} mins"
  exit
end

a = locs.first
b = locs.last

[a,b].each{|i|
  puts "#{Time.at(i.time_stamp)} #{i.reverse_geocode} (#{i.geo_lat},#{i.geo_lon})"
}
puts "and more #{locs.count-2} locations" if locs.count > 2

sp = speed(a, b).to_i
dir = direction(a, b)
puts cmd = "#{params[:tweet_cmd]} '時速#{sp}Kmで#{dir}に移動中'"
if sp < 1
  puts 'not tweet'
  exit
end
system cmd
