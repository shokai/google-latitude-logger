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

a,b = Location.desc(:time_stamp)[0..1]
p distance(a.geo_lat, a.geo_lon, b.geo_lat, b.geo_lon)

