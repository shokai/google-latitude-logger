require 'rubygems'
require 'bundler/setup'
require 'bson'
require 'mongoid'
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

Mongoid.configure{|conf|
  conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
}

class Location
  include Mongoid::Document
end
