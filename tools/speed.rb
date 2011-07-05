#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require File.dirname(__FILE__)+'/../helper'

R = 6378137

def distance(lat_a, lon_a, lat_b, lon_b)
  d_lon = (lon_a - lon_b).abs*(Math::PI / 180) # 経度
  d_lat = (lat_a - lat_b).abs*(Math::PI / 180) # 緯度
  d_y = R * d_lon * Math.cos(lat_a*(Math::PI/180))
  d_x = R * d_lat
  Math.sqrt(d_x*d_x + d_y*d_y)
end

def speed(a, b)
  a_b = distance(a.geo_lat, a.geo_lon, b.geo_lat, b.geo_lon)
  a_b/(a.time_stamp-b.time_stamp)*60*60/1000 # km/h
end

locs = Location.desc(:time_stamp)
for i in 0...locs.size-1 do
  s = speed(locs[i], locs[i+1])
  time = Time.at locs[i].time_stamp
  puts "#{s}(km/h), #{locs[i+1].reverse_geocode}, #{time}"
end
