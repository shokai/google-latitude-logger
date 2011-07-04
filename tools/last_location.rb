#!/usr/bin/env ruby
require 'rubygems'
require File.dirname(__FILE__)+'/../helper'

loc = @@db['locations'].find.map{|i|i}.reverse.first
p loc



