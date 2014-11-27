$:.unshift File.expand_path('../lib', __FILE__)
require 'gallery/api'
require 'boxes/mongodb'

Boxes.configure_mongo_mapper

run Gallery::Api