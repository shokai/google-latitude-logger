#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require File.expand_path '../helper', File.dirname(__FILE__)

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

locs = Location.desc(:time_stamp).limit(40)
for i in 0...locs.size-1 do
  s = speed(locs[i], locs[i+1])
  time = Time.at locs[i].time_stamp
  next if locs[i].time_stamp - locs[i+1].time_stamp > 60*3
  dir = direction(locs[i], locs[i+1])
  puts "#{s}(km/h), #{dir}, #{locs[i+1].reverse_geocode}, #{time}"
end
